{ ... }:
{
  users.users.martin = {
    isNormalUser = true;
    description = "Martin";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "docker"
      "plugdev"
    ];
    # Bash by default; user can `chsh -s $(which zsh)` if desired.
    # First login: set with `passwd martin` after boot. Deferred to hardening PR
    # to add initialHashedPassword securely.
  };

  security.sudo.wheelNeedsPassword = true;

  # No mutable users beyond the ones defined here.
  users.mutableUsers = true;
}
