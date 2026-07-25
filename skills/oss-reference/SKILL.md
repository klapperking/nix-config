---
name: oss-reference
description: Clone versioned OSS repositories as shared references and manage them with add, prune, and list subcommands.
---

## Overview

`oss-ref` clones open-source repositories at a specific version into a shared references root, then creates a consumer-side symlink. This avoids duplicate clones across projects. The pruner removes orphaned references that no longer have incoming symlinks, and the list command shows everything currently stored.

## Usage

### add

**Signature:** `oss-ref add <git-url> <version> <symlink-path>`

Clones `<git-url>` at `<version>` into `$OSS_REFERENCES_ROOT/<slug>@<version>`, then symlinks it to `<symlink-path>`. The slug is derived from the URL basename with `.git` stripped. The version is sanitized: slashes become dashes, only `[A-Za-z0-9._+-]` is kept, and consecutive dashes are collapsed.

The clone is staged in `$ROOT/.partial/<slug>@<version>.PID` and moved atomically to the final location. A shallow clone is attempted first; if the version is a SHA or an unknown ref, it falls back to a blobless clone followed by checkout.

**Example:**

```bash
oss-ref add https://github.com/Effect-TS/effect.git v4-beta ~/code/my-project/repos/effect
```

**Exit codes:**

- `0` — success
- `1` — runtime error (clone failed, target already exists)
- `2` — usage error (wrong number of arguments)

### prune

**Signature:** `oss-ref prune [--yes|--dry-run] [--min-age <dur>] [-v]`

Scans `$OSS_REFERENCES_ROOT` for directories matching `*@*` and checks whether any symlink under `$OSS_REFERENCES_CONSUMER_ROOTS` points to them. Unreferenced clones are candidates for deletion. The `--min-age` flag skips clones newer than the specified duration, which protects recently added references whose consumer symlinks may not yet exist.

**Example:**

```bash
oss-ref prune --yes --min-age 7d
```

**Exit codes:**

- `0` — success (or nothing to prune)
- `1` — runtime error
- `2` — usage error (invalid flag, missing value, or non-tty without `--yes`/`--dry-run`)

### list

**Signature:** `oss-ref list`

Lists all versioned clones under `$OSS_REFERENCES_ROOT`, sorted alphabetically.

**Example:**

```bash
oss-ref list
```

**Exit codes:**

- `0` — success (or empty list)
- `1` — runtime error
- `2` — usage error (not applicable for this subcommand)

## Filesystem layout

```
$OSS_REFERENCES_ROOT/
├── effect-ts@v4-beta/          # finished clone
├── .partial/
│   └── effect-ts@v4-beta.12345 # staging directory during clone (PID suffix)
└── ...

~/code/my-project/
└── repos/
    └── effect -> /Users/martin/code/others/oss-references/effect-ts@v4-beta
```

The `.partial/` directory holds in-progress clones. Every `add` run cleans entries older than 60 minutes before starting a new clone. Once the clone finishes, the staging directory is moved atomically to its final `<slug>@<version>` name.

## Safety model

`--min-age` measures the mtime of the versioned clone directory in minutes. A clone newer than the threshold is skipped during prune, even if it has no incoming symlinks. This protects against a race where a reference is added but its consumer symlink has not yet been created.

The launchd agent runs `oss-ref prune --yes --min-age 7d` weekly on Monday at 09:00. The 7-day window is wide enough that any normal project setup will have created its symlinks long before the pruner runs.

Run `oss-ref prune` manually when you know a project has been deleted or its symlinks removed, and you want to reclaim disk space immediately. Use `--dry-run` first to preview what would be removed.

## Migrating legacy clones

Any pre-existing unversioned directory under `$OSS_REFERENCES_ROOT` (for example, `effect-ts/`) is invisible to the pruner because it lacks the `@<version>` suffix. The pruner only considers directories matching `*@*`.

To migrate a legacy clone manually, rename it with a version suffix and update the consumer symlink:

```bash
mv effect-ts effect-ts@v4-beta-legacy
ln -sfn "$OSS_REFERENCES_ROOT/effect-ts@v4-beta-legacy" /path/to/consumer/repos/effect
```

This is a manual, one-off step. It is not automated.
