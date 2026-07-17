{
  pkgs,
  ...
}:
{
  # TODO: Don't search for updates.
  programs.vscodium = {
    enable = true;

    # TODO: Fix the extension change conflicts when mutable dir is enabled
    mutableExtensionsDir = false;

    profiles = {
      default = {
        # can only be set here but applies to all profiles
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

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
            # ms-python.python
            ms-python.vscode-pylance
            charliermarsh.ruff

            batisteo.vscode-django

            # golang
            golang.go

            # TODO: Re-enable when updated to sha match
            # rust
            # rust-lang.rust-analyzer

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
              name = "sqltools";
              publisher = "mtxr";
              version = "latest";
              sha256 = "sha256-SpVFH+Qf9tpnNm4J5z3fOhWzzYP0LknDNm88JHMxkIU=";
            }
            {
              name = "rust-analyzer";
              publisher = "rust-lang";
              version = "latest";
              sha256 = "sha256-G0kG7jaDCOg0mk4c9WKITPwSAQOgllsZ40QLeEXc/Hw=";
            }
            {
              name = "oxc-vscode";
              publisher = "oxc";
              version = "latest";
              sha256 = "sha256-wosNcp6CaS7WrH3NwXnsnEdABG2G9BZxRflh+lhr9+Q=";
            }
            {
              name = "python";
              publisher = "ms-python";
              version = "latest";
              sha256 = "sha256-ft9F6Ok/0VU3P9+AAAxW51NE5RlEK6VwtFPaMYq+GLg=";
            }
            {
              name = "debugpy";
              publisher = "ms-python";
              version = "latest";
              sha256 = "sha256-fG4HozhdkB7N1c2SVr8mfs99F5np97+Lz102x7NgtY0=";
            }
            {
              name = "playwright";
              publisher = "ms-playwright";
              version = "latest";
              sha256 = "sha256-N2U+KvmqslmjXSpHovIbT/iVbSV6JrTu1UsoiolW9/Y=";
            }
            {
              name = "code-spell-checker-british-english";
              publisher = "streetsidesoftware";
              version = "latest";
              sha256 = "sha256-k0pMNGNru93SeXGJ+jeFqHZcCTjyO9qd4AhqFcuzfEU=";
            }
            {
              name = "code-spell-checker-german";
              publisher = "streetsidesoftware";
              version = "latest";
              sha256 = "sha256-zc0cv4AOswvYcC4xJOq2JEPMQ5qTj9Dad5HhxtNETEs=";
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
              sha256 = "sha256-oY+mpDv2OTy5hFEk2DMNHi9epFm4Ay4qi0drCXPuYhU=";
            }
            {
              name = "cucumberautocomplete";
              publisher = "alexkrechik";
              version = "latest";
              sha256 = "sha256-bwIwZ9cAgJcUyiFrM9rx0FzCx29F4lRQOnjw5m/bO24=";
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
              sha256 = "sha256-/lvP3a2IJ4PhwThvx0J8wDcch2te2Ezs8v0Lh9A5bpg=";
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
              sha256 = "sha256-Yh5C/Rjqtg38BT4D6IuW8Wc5Eq4GzkrpGQYU6U3T/p0=";
            }
            {
              name = "vscode-expo-tools";
              publisher = "expo";
              version = "latest";
              sha256 = "sha256-vqT/72pUyHtzl0rmUfDgbr7MO+/2dw3EcDeYTkQY/0Y=";
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

          "[sql]" = {
            "editor.defaultFormatter" = "mtxr.sqltools";
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
          "python.languageServer" = "Jedi";
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
          "window.zoomLevel" = -1;

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
    };
  };
}
