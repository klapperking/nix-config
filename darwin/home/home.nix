# TODO: Modularize
{ pkgs, ... }@inputs:
{
  home.stateVersion = "24.05";

  home.username = "martin";
  home.homeDirectory = "/Users/martin";

  # TODO: move dev-related packages into a dev-module and include for users
  home.packages = with pkgs; [
    _1password-cli
    age
    bc
    # darwin.xcode # TODO: Install xcode apple devtools
    docker_26
    firefox-devedition-bin # firefox broken on darwin, use from overlay
    # TODO: get a signed version or sign so 1password integration works
    fzf
    jq
    git
    gh-eco
    gnupg
    google-chrome
    kitty
    meslo-lgs-nf
    nixfmt-rfc-style
    # TODO: figure out how to write to /etc/pam.d/sudo to make this work
    # for tmux reattach-to-user-namespace
    # see https://github.com/LnL7/nix-darwin/issues/985 for workaround or fix
    # pam-reattach
    pinentry-tty
    rectangle
    ripgrep
    shellcheck
    tmux
    tmuxPlugins.cpu
    tmuxPlugins.prefix-highlight
    tmuxPlugins.tokyo-night-tmux
    tmuxPlugins.yank
    obsidian
    vscodium
    zsh
    zsh-powerlevel10k
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
    EDITOR = "codium";
    # use fake omz cache dir for completions
    ZSH_CACHE_DIR = "${inputs.config.home.homeDirectory}/.cache/oh-my-zsh";
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
    };

    chromium = {
      enable = true;
      package = pkgs.google-chrome; # TODO: darwin chromium overlay!
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition-bin;
      languagePacks = [
        "en-US"
        "de"
      ];
      profiles = {
        martin = {
          id = 0;
          name = "martin";
          isDefault = true;
          # mostly taken from: https://github.com/gvolpe/nix-config
          settings = {
            "app.normandy.first_run" = false;
            "app.shield.optoutstudies.enabled" = false;

            "app.update.channel" = "default";

            "browser.contentblocking.category" = "strict"; # or standard
            "browser.ctrlTab.recentlyUsedOrder" = false;

            "browser.download.useDownloadDir" = true;
            "browser.download.viewableInternally.typeWasRegistered.svg" = true;
            "browser.download.viewableInternally.typeWasRegistered.webp" = true;
            "browser.download.viewableInternally.typeWasRegistered.xml" = true;

            "browser.link.open_newwindow" = true;

            "browser.search.region" = "CH";
            "browser.search.widget.inNavBar" = true;

            "browser.shell.checkDefaultBrowser" = false;
            "browser.search.defaultenginename" = "Kagi Search";
            "browser.search.order.1" = "Kagi Search";
            "browser.startup.homepage" = "https://kagi.com";
            "browser.tabs.loadInBackground" = true;
            "browser.urlbar.placeholderName" = "Kagi";
            "browser.urlbar.showSearchSuggestionsFirst" = false;

            "browser.urlbar.quickactions.enabled" = false;
            "browser.urlbar.quickactions.showPrefs" = false;
            "browser.urlbar.shortcuts.quickactions" = true;
            "browser.urlbar.suggest.quickactions" = false;

            "distribution.searchplugins.defaultLocale" = "en-US";

            # "doh-rollout.balrog-migration-done" = true; DNS over HTTPS
            # "doh-rollout.doneFirstRun" = true;

            "dom.forms.autocomplete.formautofill" = false;

            "general.autoScroll" = true;
            "general.useragent.locale" = "en-US";

            # firefox tokyo night
            "extensions.activeThemeID" = "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}";
            "extensions.extensions.activeThemeID" = "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}";

            "extensions.update.enabled" = false;
            "extensions.webcompat.enable_picture_in_picture_overrides" = true;
            "extensions.webcompat.enable_shims" = true;
            "extensions.webcompat.perform_injections" = true;
            "extensions.webcompat.perform_ua_overrides" = true;

            "privacy.donottrackheader.enabled" = true;

            # hardware key auth settings
            # "security.webauth.u2f" = true;
            # "security.webauth.webauthn" = true;
            # "security.webauth.webauthn_enable_softtoken" = true;
            # "security.webauth.webauthn_enable_usbtoken" = true;

            "accessibility.force_disabled" = 1;

            # disable Normandy/Shield
            "app.normandy.api_url" = "";
            "app.normandy.enabled" = false;

            # personalized Extension Recommendations in about:addons and AMO [FF65+]
            # https://support.mozilla.org/kb/personalized-extension-recommendations
            "browser.discovery.enabled" = false;
            "browser.helperApps.deleteTempFileOnExit" = true;

            "browser.newtabpage.activity-stream.default.sites" = "";
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.uitour.enabled" = false;

            # use Mozilla geolocation service instead of Google.
            #"geo.provider.network.url"= "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
            # disable using the OS's geolocation service
            "geo.provider.use_gpsd" = false;
            "geo.provider.use_geoclue" = false;

            # HIDDEN PREF: disable recommendation pane in about:addons
            "extensions.getAddons.showPane" = false;
            # recommendations in about:addons' Extensions and Themes panes [FF68+]
            "extensions.htmlaboutaddons.recommendations.enabled" = false;

            # disable Network Connectivity checks
            "network.connectivity-service.enabled" = false;

            # integrated calculator
            "browser.urlbar.suggest.calculator" = true;

            # TELEMETRY
            # disable new data submission
            "datareporting.policy.dataSubmissionEnabled" = false;
            # disable Health Reports
            "datareporting.healthreport.uploadEnabled" = false;
            # 0332: disable telemetry
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            # disable Telemetry Coverage
            "toolkit.telemetry.coverage.opt-out" = true; # [HIDDEN PREF]
            "toolkit.coverage.opt-out" = true; # [FF64+] [HIDDEN PREF]
            "toolkit.coverage.endpoint.base" = "";
            # disable PingCentre telemetry
            "browser.ping-centre.telemetry" = false;
            # disable Firefox Home (Activity Stream) telemetry
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false;
            "browser.vpn_promo.enabled" = false;
          };

          search = {
            force = true;
            default = "Kagi Search";
            order = [
              "Kagi Search"
              "DuckDuckGo"
              "Google"
            ];
            engines = {
              "Kagi Search" = {
                urls = [
                  {
                    # TODO: Use kagi session token when sops is set up
                    # TODO: Aliases for lenses
                    template = "https://kagi.com/search?q={searchTerms}";
                  }
                ];
                icon = "https://assets.kagi.com/v2/favicon-32x32.png";
                definedAliases = [ "@ks" ];
              };
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "NixOS Wiki" = {
                urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@nw" ];
              };
              "MyNixOS" = {
                urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
                iconUpdateURL = "https://mynixos.com/favicon-32x32.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@nc" ];
              };
              "Nixhub.io" = {
                urls = [ { template = "https://nixhub.io/search?q={searchTerms}"; } ];
                iconUpdateURL = "https://www.nixhub.io/favicon.ico";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@nh" ];
              };
              "DuckDuckGo".metaData.alis = "@d";
              "Bing".metaData.hidden = true;
              "Google".metaData.alias = "@g";
            };
          };

          # TODO: Persist extension configs separately
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            canvasblocker
            darkreader
            decentraleyes
            onepassword-password-manager
            privacy-badger
            react-devtools
            reduxdevtools
            tokyo-night-v2
            ublock-origin
            user-agent-string-switcher
            unpaywall
            to-deepl
            link-cleaner
            # epub-reader
            # gql network inspector
          ];
        };
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      # tmux.enableShellIntegrationOptions = [];
      # TODO: fzf history settings
    };

    git = {
      aliases = {
        st = "status -sb";
        fo = "fetch origin";
        d = "!git --no-pager diff";
        dt = "difftool";
        stat = "!git --no-pager diff --stat";

        # Set remotes/origin/HEAD -> defaultBranch (copied from https://stackoverflow.com/a/67672350/14870317)
        remoteSetHead = "remote set-head origin --auto";

        # Get default branch name (copied from https://stackoverflow.com/a/67672350/14870317)
        defaultBranch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -d'/' -f4";

        # Clean merged branches (adapted from https://stackoverflow.com/a/6127884/14870317)
        sweep = "!git branch --merged $(git defaultBranch) | grep -E -v ' $(git defaultBranch)$' | xargs -r git branch -d && git remote prune origin";

        # http://www.jukie.net/bart/blog/pimping-out-git-log
        lg = "log --graph --all --pretty=format:'%Cred%h%Creset - %s %Cgreen(%cr) %C(bold blue)%an%Creset %C(yellow)%d%Creset'";

        # Serve local repo. http://coderwall.com/p/eybtga
        # Then other can access via `git clone git://#{YOUR_IP_ADDRESS}/
        serve = "!git daemon --reuseaddr --verbose  --base-path=. --export-all ./.git";

        # Checkout to defaultBranch
        m = "!git checkout $(git defaultBranch)";

        # Removes a file from the index
        unstage = "reset HEAD --";
      };
      enable = true;
      extraConfig = {
        branch = {
          master = {
            mergeoptions = "--no-edit";
          };
        };
        color = {
          branch = {
            current = "green";
            remote = "yellow";
          };
          diff = "auto";
          interactive = "auto";
          status = true;
          ui = true;
        };
        core = {
          editor = "codium --wait";
          pager = "less -FRSX";
        };
        help = {
          autocorrect = 1;
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = "true";
        };
        push = {
          default = "simple";
        };
        rerere = {
          enabled = true;
        };
      };
      signing = {
        key = null;
        signByDefault = true;
      };
      userName = "Martin Klapper";
      userEmail = "martin@ax.tech";
    };

    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-eco
      ];
      gitCredentialHelper = {
        enable = true;
        hosts = [ "https://github.com" ];
      };
    };

    gpg = {
      enable = true;
    };

    kitty = with pkgs; {
      enable = true;
      extraConfig = ''
        # fake tokyo night style theme
        background #222436
        foreground #c8d3f5
        selection_background #2d3f76
        selection_foreground #c8d3f5
        url_color #4fd6be
        cursor #c8d3f5
        cursor_text_color #222436

        active_tab_background #82aaff
        active_tab_foreground #1e2030
        inactive_tab_background #2f334d
        inactive_tab_foreground #545c7e
        tab_bar_background #1b1d2b

        active_border_color #82aaff
        inactive_border_color #2f334d

        color0 #1b1d2b
        color1 #ff757f
        color2 #c3e88d
        color3 #ffc777
        color4 #82aaff
        color5 #c099ff
        color6 #86e1fc
        color7 #828bb8

        color8 #444a73
        color9 #ff757f
        color10 #c3e88d
        color11 #ffc777
        color12 #82aaff
        color13 #c099ff
        color14 #86e1fc
        color15 #c8d3f5

        color16 #ff966c
        color17 #c53b53

        # Nerd Fonts v3.2.0
        symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono
      '';

      font = {
        name = "MesloLGS NF";
        package = meslo-lgs-nf;
        size = 13;
      };
      settings = {
        hide_window_decorations = true;
      };
      shellIntegration.enableZshIntegration = true;
    };

    thefuck = {
      enable = true;
      enableZshIntegration = true;
    };

    tmux = {
      enable = true;

      baseIndex = 1;
      extraConfig = ''
        # Allow x-keys (like C-left to move by full word)
        set-option -g xterm-keys on

        # bind ctrl + Arrowkeys to navigate in cli
        bind -n M-Left send-keys M-b
        bind -n M-Right send-keys M-f

        # bind pane-sync to ctrl + b + g
        bind C-g set-window-option synchronize-panes

        # Temporarily re-set the shell var for use with tmux sensibleOnTop
        # see: https://github.com/nix-community/home-manager/issues/5952
        set -gu default-command
        set -g default-shell "$SHELL"
      '';
      clock24 = true;
      mouse = true;
      plugins = with pkgs; [
        # {
        #   plugin = tmuxPlugins.cpu;
        #   extraConfig = ''
        #     set -g status-right '#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M '
        #   '';
        # }
        {
          plugin = tmuxPlugins.tokyo-night-tmux;
          extraConfig = ''
            # common macOS L; no unicode support
            set -g @tokyo-night-tmux_window_id_style none
          '';
        }
        tmuxPlugins.yank
      ];
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      tmuxinator.enable = true;
    };

    vscode = with pkgs; {
      enable = true;
      package = vscodium;

      # TODO: Fix the extension change conflicts when mutable dir is enabled
      mutableExtensionsDir = false;

      # TODO: and/or move to extensions module in e.g. /home/vscode
      extensions =
        with pkgs.vscode-extensions;
        with pkgs.vscode-utils;
        [
          # nix
          bbenoist.nix
          brettm12345.nixfmt-vscode

          # md
          yzhang.markdown-all-in-one
          unifiedjs.vscode-mdx

          # yaml
          redhat.vscode-yaml

          # python
          ms-python.python
          ms-python.vscode-pylance
          charliermarsh.ruff

          batisteo.vscode-django

          # golang
          golang.go

          # rust
          rust-lang.rust-analyzer

          # gql
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax

          # js/ts
          christian-kohler.npm-intellisense
          yoavbls.pretty-ts-errors

          # html/css
          bradlc.vscode-tailwindcss
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag
          vincaslt.highlight-matching-tag
          naumovs.color-highlight

          # format
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode

          # git / github
          eamodio.gitlens

          github.copilot
          github.vscode-github-actions
          github.vscode-pull-request-github

          # other
          christian-kohler.path-intellisense
          emmanuelbeziat.vscode-great-icons
          firefox-devtools.vscode-firefox-debug
          mikestead.dotenv
          wix.vscode-import-cost
          usernamehw.errorlens
          streetsidesoftware.code-spell-checker
          shardulm94.trailing-spaces
          aaron-bond.better-comments
        ]
        ++ extensionsFromVscodeMarketplace [
          {
            name = "playwright";
            publisher = "ms-playwright";
            version = "latest";
            sha256 = "sha256-B6RYsDp1UKZmBRT/GdTPqxGOyCz2wJYKAqYqSLsez+w=";
          }
          {
            name = "code-spell-checker-british-english";
            publisher = "streetsidesoftware";
            version = "latest";
            sha256 = "sha256-S1lGUMENNjMHUnNmgG4FihK0fFtDfluTKJ3v9tyiGJ4=";
          }
          {
            name = "code-spell-checker-german";
            publisher = "streetsidesoftware";
            version = "latest";
            sha256 = "sha256-40Oc6ycNog9cxG4G5gCps2ADrM/wLuKWFrD4lnd91Z4=";
          }
          {
            name = "vscode-todo-highlight";
            publisher = "wayou";
            version = "latest";
            sha256 = "sha256-CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
          }
          {
            name = "tokyo-night-moon";
            publisher = "patricknasralla";
            version = "latest";
            sha256 = "sha256-8rUbsDCk7JHSN4vn+TNTmIrx8ma53hH/1x0trqDwU7Y=";
          }
          {
            name = "vscode-css-peek";
            publisher = "pranaygp";
            version = "latest";
            sha256 = "sha256-GX6J9DfIW9CLarSCfWhJQ9vvfUxy8QU0kh3cfRUZIaE=";
          }
          {
            name = "cucumberautocomplete";
            publisher = "alexkrechik";
            version = "latest";
            sha256 = "sha256-Tgqd4uoVgGJQKlj4JUM1CrjQhbi0qv9bAGz5NIHyofQ=";
          }
          {
            name = "language-gettext";
            publisher = "mrorz";
            version = "latest";
            sha256 = "sha256-1hdT2Fai0o48ojNqsjW+McokD9Nzt2By3vzhGUtgaeA=";
          }
          {
            name = "vscode-typescript-next";
            publisher = "ms-vscode";
            version = "latest";
            sha256 = "sha256-ZYJ2+d7xZVMpsFilUxNPx52AiBPAP3GYfhzcyersqhc=";
          }
          {
            name = "react-proptypes-intellisense";
            publisher = "ofhumanbondage";
            version = "latest";
            sha256 = "sha256-lmAjqOR+rznx5Q7W/ChRg8sb1NhqN2YtrwRn8zHYtRo=";
          }
          {
            name = "shellcheck";
            publisher = "timonwong";
            version = "latest";
            sha256 = "sha256-JSS0GY76+C5xmkQ0PNjt2Nu/uTUkfiUqmPL51r64tl0=";
          }
        ];

      keybindings = [
        {
          key = "alt+control+right";
          command = "cursorWordPartRight";
          when = "editorTextFocus";
        }
        {
          key = "alt+control+left";
          command = "cursorWordPartLeft";
          when = "editorTextFocus";
        }
        {
          key = "alt+control+shitft+left";
          command = "cursorWordPartLeftSelect";
          when = "editorTextFocus";
        }
        {
          key = "alt+control+shitft+right";
          command = "cursorWordPartRightSelect";
          when = "editorTextFocus";
        }
      ];

      userSettings = {
        # Python specific settings
        "[python]" = {
          "editor.bracketPairColorization.enabled" = false;
          "editor.guides.bracketPairs" = true;
          "editor.tabSize" = 4;
          "editor.defaultFormatter" = "charliermarsh.ruff";
          "editor.formatOnSave" = true;
          "diffEditor.ignoreTrimWhitespace" = true;
        };

        "[nix]" = {
          "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
        };

        # General editor settings
        "editor.bracketPairColorization.enabled" = true;
        "editor.cursorStyle" = "block";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.detectIndentation" = false;
        "editor.fontSize" = 14;
        "editor.formatOnSave" = true;
        "editor.gotoLocation.multipleDefinitions" = "gotoAndPeek";
        "editor.guides.bracketPairs" = true;
        "editor.minimap.enabled" = false;
        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.renderControlCharacters" = true;
        "editor.rulers" = [
          80
          120
        ];
        "editor.showFoldingControls" = "always";
        "editor.snippetSuggestions" = "top";
        "editor.tabSize" = 2;
        "emmet.includeLanguages" = {
          "erb" = "html";
        };
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
        };
        "editor.quickSuggestions" = {
          "other" = "on";
          "comments" = "off";
          "strings" = "on";
        };
        "emmet.showSuggestionsAsSnippets" = true;
        "emmet.triggerExpansionOnTab" = true;
        "explorer.confirmDelete" = false;

        # File settings
        "files.associations" = {
          ".css" = "tailwindcss";
        };
        "files.exclude" = {
          "__pycache__" = true;
          "_site" = true;
          ".asset-cache" = true;
          ".bundle" = true;
          ".ipynb_checkpoints" = true;
          ".pytest_cache" = true;
          ".sass-cache" = true;
          ".svn" = true;
          "**/.DS_Store" = true;
          "**/.egg-info" = true;
          "**/.git" = true;
          "build" = true;
          "coverage" = true;
          "dist" = true;
          "log" = true;
          "node_modules" = false;
          "public/packs" = true;
          "tmp" = true;
        };
        "files.hotExit" = "off";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "files.watcherExclude" = {
          "**/audits/**" = true;
          "**/coverage/**" = true;
          "**/log/**" = true;
          "**/node_modules/**" = true;
          "**/tmp/**" = true;
          "**/vendor/**" = true;
        };

        # Notebook settings
        "notebook.diff.ignoreMetadata" = true;
        "notebook.lineNumbers" = "on";
        "notebook.markup.fontSize" = 13;

        # Python settings
        "python.analysis.typeCheckingMode" = "basic";
        "python.analysis.autoImportCompletions" = true;
        "python.languageServer" = "Pylance";
        "python.terminal.activateEnvironment" = false;

        # Tailwind CSS settings
        "tailwindCSS.experimental.classRegex" = [
          [
            "cva\\(([^)]*)\\)"
            "[\"'`]([^\"'`]*).*?[\"'`]"
          ]
          [
            "cx\\(([^)]*)\\)"
            "(?:'|\"|`)([^']*)(?:'|\"|`)"
          ]
        ];

        # Window settings
        "window.restoreWindows" = "none";
        "window.newWindowDimensions" = "maximized";

        # Workbench settings
        "workbench.editor.enablePreview" = true;
        "workbench.settings.editor" = "json";
        "workbench.settings.openDefaultSettings" = false;
        "workbench.settings.useSplitJSON" = true;
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.panel.defaultLocation" = "bottom";
        "security.workspace.trust.untrustedFiles" = "open";
        "workbench.sideBar.location" = "right";
        "workbench.colorTheme" = "Tokyo Night Moon";
        "workbench.iconTheme" = "vscode-great-icons";

        # Accessibility support
        "editor.accessibilitySupport" = "off";

        # Spell check settings
        "cSpell.language" = "en,de-DE,en-GB,en-US,de";

        # TypeScript settings
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "typescript.preferences.importModuleSpecifier" = "non-relative";

        # Playwright settings
        "playwright.reuseBrowser" = true;

        # GitHub settings
        "githubPullRequests.pullBranch" = "never";
        "go.toolsManagement.autoUpdate" = true;
        "git.openRepositoryInParentFolders" = "always";
        "github.copilot.editor.enableAutoCompletions" = true;

        # Terminal settings
        "terminal.external.osxExec" = "kitty.app";

        # Editor associations
        "workbench.editorAssociations" = {
          "git-rebase-todo" = "default";
        };

        # Diff editor settings
        "diffEditor.ignoreTrimWhitespace" = false;

        # Makefile settings
        "makefile.configureOnOpen" = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      # p10k config
      # you should use position after the commands output
      initExtra = ''
        # extra config (before aliases)
        source ~/.p10k.zsh
        export YSU_MESSAGE_POSITION="after"
        unalias rm # unalias rm -i from common-aliases
      '';

      plugins =
        with pkgs;
        let
          # Using lots of plugins from omz: https://github.com/ohmyzsh/ohmyzsh
          omzPlugins = fetchFromGitHub {
            owner = "ohmyzsh";
            repo = "ohmyzsh";
            rev = "master";
            sha256 = "sha256-rI673tQ3W4U9N5i8LZx9dpKzft7+Y0UZ7iTSJwnoSSE=";
          };
        in
        [
          {
            name = "zsh-powerlevel10k";
            src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k/";
            file = "powerlevel10k.zsh-theme";
          }
          {
            name = "zsh-you-should-use";
            src = fetchFromGitHub {
              owner = "MichaelAquilina";
              repo = "zsh-you-should-use";
              rev = "1.9.0";
              sha256 = "sha256-+3iAmWXSsc4OhFZqAMTwOL7AAHBp5ZtGGtvqCnEOYc0=";
            };
            file = "you-should-use.plugin.zsh";
          }
          # Omz plugins
          {
            name = "directories";
            src = "${omzPlugins}/lib";
            file = "directories.zsh";
          }
          {
            name = "git";
            src = "${omzPlugins}/plugins/git";
            file = "git.plugin.zsh";
          }
          {
            name = "git-commit";
            src = "${omzPlugins}/plugins/git-commit";
            file = "git-commit.plugin.zsh";
          }
          {
            name = "common-aliases";
            src = "${omzPlugins}/plugins/common-aliases";
            file = "common-aliases.plugin.zsh";
          }
          {
            name = "gh";
            src = "${omzPlugins}/plugins/gh";
            file = "gh.plugin.zsh";
          }
          {
            name = "docker";
            src = "${omzPlugins}/plugins/docker";
            file = "docker.plugin.zsh";
          }
          {
            name = "docker-compose";
            src = "${omzPlugins}/plugins/docker-compose";
            file = "docker-compose.plugin.zsh";
          }
        ];

      syntaxHighlighting.enable = true;
      shellAliases = {
        myip = "curl https://ipinfo.io/json";
        # TODO: don't use system python
        speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -";

        pn = "pnpm";
      };
      # TODO: History options
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };
}
