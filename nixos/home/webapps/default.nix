{ pkgs, ... }:
let
  # Helper: generate a Chromium --app=<url> desktop entry.
  webapp =
    {
      name,
      url,
      categories ? [ "Network" ],
      genericName ? "Web Application",
    }:
    {
      inherit name categories genericName;
      exec = "${pkgs.chromium}/bin/chromium --app=${url}";
      terminal = false;
      type = "Application";
      icon = "chromium-browser";
    };
in
{
  # Omarchy web-app launchers. Available via Walker (Super+Space) and via
  # Hyprland keybinds ($mod Shift {A,C,E,Y,G,X,P,S,…}). Fizzy skipped —
  # URL not clearly documented in Omarchy's install/packaging/webapps.sh.
  xdg.desktopEntries = {
    omarchy-hey = webapp {
      name = "HEY";
      url = "https://app.hey.com";
      genericName = "Email";
      categories = [
        "Network"
        "Email"
      ];
    };
    omarchy-basecamp = webapp {
      name = "Basecamp";
      url = "https://launchpad.37signals.com";
    };
    omarchy-whatsapp = webapp {
      name = "WhatsApp";
      url = "https://web.whatsapp.com";
    };
    omarchy-chatgpt = webapp {
      name = "ChatGPT";
      url = "https://chatgpt.com";
    };
    omarchy-grok = webapp {
      name = "Grok";
      url = "https://grok.com";
    };
    omarchy-youtube = webapp {
      name = "YouTube";
      url = "https://youtube.com";
    };
    omarchy-github = webapp {
      name = "GitHub";
      url = "https://github.com";
    };
    omarchy-x = webapp {
      name = "X";
      url = "https://x.com";
    };
    omarchy-x-compose = webapp {
      name = "X Compose";
      url = "https://x.com/compose/post";
    };
    omarchy-figma = webapp {
      name = "Figma";
      url = "https://figma.com";
    };
    omarchy-discord = webapp {
      name = "Discord";
      url = "https://discord.com/app";
    };
    omarchy-zoom = webapp {
      name = "Zoom";
      url = "https://zoom.us";
    };
    omarchy-google-photos = webapp {
      name = "Google Photos";
      url = "https://photos.google.com";
    };
    omarchy-google-contacts = webapp {
      name = "Google Contacts";
      url = "https://contacts.google.com";
    };
    omarchy-google-messages = webapp {
      name = "Google Messages";
      url = "https://messages.google.com/web";
    };
    omarchy-google-maps = webapp {
      name = "Google Maps";
      url = "https://maps.google.com";
    };
    omarchy-google-calendar = webapp {
      name = "Google Calendar";
      url = "https://calendar.google.com";
    };
  };
}
