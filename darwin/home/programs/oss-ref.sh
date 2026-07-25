#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

readonly ROOT="${OSS_REFERENCES_ROOT:-$HOME/code/others/oss-references}"
# shellcheck disable=SC2034
readonly CONSUMER_ROOTS="${OSS_REFERENCES_CONSUMER_ROOTS:-$HOME/code}"

sanitize_version() {
  echo "$1" | tr '/' '-' | tr -cs 'A-Za-z0-9._+-' '-' | sed -E 's/-+/-/g; s/^-|-$//g'
}

derive_slug() {
  basename "$1" .git
}

_log() {
  local level="$1" color="" reset=""
  shift

  if [[ -t 2 ]]; then
    reset=$'\033[0m'
    case "$level" in
      info) color=$'\033[32m' ;;
      warn) color=$'\033[33m' ;;
      error) color=$'\033[31m' ;;
    esac
  fi

  case "$level" in
    info) printf '%s[oss-ref] %s%s\n' "$color" "$*" "$reset" >&2 ;;
    warn) printf '%s[oss-ref] WARN: %s%s\n' "$color" "$*" "$reset" >&2 ;;
    error) printf '%s[oss-ref] ERROR: %s%s\n' "$color" "$*" "$reset" >&2 ;;
  esac
}

log_info() {
  [[ ${verbose:-0} -eq 1 ]] || return 0
  _log info "$*"
}

log_warn() {
  _log warn "$*"
}

log_err() {
  _log error "$*"
}

confirm() {
  local message="$1" default_no="${2:-1}" reply prompt

  [[ -t 0 ]] || return 1

  if [[ "$default_no" -eq 1 ]]; then
    prompt='[y/N]'
  else
    prompt='[Y/n]'
  fi

  printf '%s %s ' "$message" "$prompt" >&2
  IFS= read -r reply || return 1

  case "$reply" in
    y|Y|yes|YES) return 0 ;;
    n|N|no|NO) return 1 ;;
    '') [[ "$default_no" -eq 0 ]] ;;
    *) return 1 ;;
  esac
}

cmd_help() {
  cat <<'HELP'
Usage: oss-ref <subcommand> [args]

Subcommands:
  add <git-url> <version> <symlink-path>   Clone <git-url>@<version> under the references root and symlink from <symlink-path>.
  prune [--yes|--dry-run] [--min-age <dur>] [-v]   Remove reference clones with no incoming symlinks under configured consumer roots.
  list                                            List all versioned clones under the references root.
  help                                            Show this message.

Environment:
  OSS_REFERENCES_ROOT          Root directory for clones. Default: $HOME/code/others/oss-references
  OSS_REFERENCES_CONSUMER_ROOTS Colon-separated roots the pruner scans for incoming symlinks. Default: $HOME/code
HELP
}

cmd_list() {
  find "$ROOT" -mindepth 1 -maxdepth 1 -type d -name '*@*' -exec basename {} \; 2>/dev/null | sort
}

cmd_add() {
  [[ $# -eq 3 ]] || { log_err "usage: oss-ref add <git-url> <version> <symlink-path>"; exit 2; }
  local url="$1" version="$2" symlink_path="$3"

  mkdir -p "$ROOT"

  # Clean stale partials older than 60 minutes
  if [[ -d "$ROOT/.partial" ]]; then
    find "$ROOT/.partial" -mindepth 1 -maxdepth 1 -type d -mmin +60 -exec rm -rf {} + 2>/dev/null || true
  fi

  local slug version_safe target
  slug=$(derive_slug "$url")
  version_safe=$(sanitize_version "$version")
  target="$ROOT/$slug@$version_safe"

  # Collision check
  if [[ -e "$target" ]]; then
    log_err "already exists: $target"
    exit 1
  fi

  mkdir -p "$ROOT/.partial"
  local staging="$ROOT/.partial/$slug@$version_safe.$$" diagnostics
  diagnostics=$(mktemp "${TMPDIR:-/tmp}/oss-clone.XXXXXX")
  chmod 600 "$diagnostics"

  # Trap: remove diagnostics and staging on any exit
  trap 'rm -f "$diagnostics"; rm -rf "$staging"; rmdir "$ROOT/.partial" 2>/dev/null || true' EXIT INT TERM

  # Try shallow clone by branch/tag first
  if ! git clone --depth=1 --branch "$version" "$url" "$staging" 2>"$diagnostics"; then
    # Check if it's a ref-not-found error; if so try full clone + checkout (SHA fallback)
    if grep -qiE 'Remote branch .* not found|no such ref|Could not find remote branch|warning: Could not find remote branch' "$diagnostics" 2>/dev/null || \
       grep -qiE 'fatal: .*(not found|invalid)' "$diagnostics" 2>/dev/null; then
      rm -rf "$staging"
      git clone --filter=blob:none "$url" "$staging" 2>"$diagnostics" || exit 1
      git -C "$staging" checkout "$version" 2>"$diagnostics" || exit 1
    else
      exit 1
    fi
  fi

  # Atomic swap
  mv "$staging" "$target"
  rm -f "$diagnostics"
  trap - EXIT INT TERM

  # Symlink: parent auto-mkdir, -n prevents following existing symlink
  mkdir -p "$(dirname "$symlink_path")"
  ln -sfn "$target" "$symlink_path"
  rmdir "$ROOT/.partial" 2>/dev/null || true

  echo "Created: $target"
  echo "Symlink: $symlink_path -> $target"

  if confirm "Run 'oss-ref prune' to check for orphans now?" 1; then
    cmd_prune
  fi
}

cmd_prune() {
  local assume_yes=0 dry_run=0 min_age_min=0 verbose=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --yes)      assume_yes=1; shift ;;
      --dry-run)  dry_run=1; shift ;;
      --min-age)
        [[ $# -ge 2 ]] || { log_err "usage: --min-age requires a value"; exit 2; }
        local age_arg="$2"; shift 2
        if [[ ! "$age_arg" =~ ^[0-9]+[dhm]$ ]]; then
          log_err "usage: --min-age format: Nd, Nh, Nm"
          exit 2
        fi
        case "$age_arg" in
          *d) min_age_min=$(( ${age_arg%d} * 1440 )) ;;
          *h) min_age_min=$(( ${age_arg%h} * 60 )) ;;
          *m) min_age_min=${age_arg%m} ;;
        esac
        ;;
      -v)         verbose=1; shift ;;
      *)          log_err "usage: oss-ref prune [--yes|--dry-run] [--min-age <dur>] [-v]"; exit 2 ;;
    esac
  done

  # Missing root is not an error
  if [[ ! -d "$ROOT" ]]; then
    echo "nothing to prune (root missing: $ROOT)"
    exit 0
  fi

  # Enumerate versioned clone candidates
  local -a candidates
  mapfile -t candidates < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d -name '*@*' 2>/dev/null)

  # Non-tty guard: refuse interactive prompt on non-tty stdin
  if [[ $dry_run -eq 0 && $assume_yes -eq 0 && ! -t 0 ]]; then
    log_err "refusing to prompt on non-tty; pass --yes or --dry-run"
    exit 2
  fi

  # Collect referenced targets by scanning consumer roots
  local -A referenced
  local IFS_ORIG="$IFS"
  IFS=':'
  # shellcheck disable=SC2206
  local -a roots=($CONSUMER_ROOTS)
  IFS="$IFS_ORIG"

  for consumer_root in "${roots[@]}"; do
    log_info "Scanning: $consumer_root"
    if [[ -d "$consumer_root" ]]; then
      local resolved
      while IFS= read -r -d '' resolved; do
        referenced["$resolved"]=1
      done < <(find "$consumer_root" -type l -exec readlink -fz -- {} + 2>/dev/null)
    fi
  done

  if [[ ${#candidates[@]} -eq 0 ]]; then
    echo "nothing to prune"
    exit 0
  fi

  # Process each candidate
  local pruned=0
  for candidate in "${candidates[@]}"; do
    local canonical
    canonical=$(cd "$candidate" && pwd -P 2>/dev/null) || canonical="$candidate"

    if [[ -n "${referenced[$canonical]+x}" || -n "${referenced[$candidate]+x}" ]]; then
      continue  # still referenced
    fi

    # Check min-age
    if [[ "$min_age_min" -gt 0 ]]; then
      local mtime_min
      # Try GNU stat first, then BSD stat
      mtime_min=$(stat -c '%Y' "$candidate" 2>/dev/null) || mtime_min=$(stat -f '%m' "$candidate" 2>/dev/null) || mtime_min=0
      local now_s
      now_s=$(date +%s)
      local age_min=$(( (now_s - mtime_min) / 60 ))
      if [[ "$age_min" -lt "$min_age_min" ]]; then
        log_info "Keeping (too new): $(basename "$candidate")"
        continue
      fi
    fi

    if [[ "$dry_run" -eq 1 ]]; then
      echo "$(basename "$candidate")  orphan"
      continue
    fi

    if [[ "$assume_yes" -eq 1 ]]; then
      rm -rf "$candidate"
      echo "Pruned: $(basename "$candidate")"
      pruned=$(( pruned + 1 ))
    else
      if confirm "Delete orphan $(basename "$candidate")?" 1; then
        rm -rf "$candidate"
        echo "Pruned: $(basename "$candidate")"
        pruned=$(( pruned + 1 ))
      fi
    fi
  done

  if [[ "$dry_run" -eq 0 && "$pruned" -eq 0 ]]; then
    echo "nothing to prune"
  fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] || return 0

case "${1:-}" in
  add) shift; cmd_add "$@" ;;
  prune) shift; cmd_prune "$@" ;;
  list) shift; cmd_list "$@" ;;
  help|--help|-h) cmd_help; exit 0 ;;
  '') cmd_help; exit 0 ;;
  *) log_err "usage: oss-ref <add|prune|list|help>"; exit 2 ;;
esac
