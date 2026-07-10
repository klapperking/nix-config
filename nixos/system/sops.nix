{ ... }:
{
  # sops-nix wiring. See ~/Downloads/security-hardened-secrets-runbook(1).md §Phase 3.
  #
  # Post-install workflow (one-time per host):
  #   1. On the target: `ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub`
  #   2. Add the resulting `age1...` to `.sops.yaml` under `&linux`.
  #   3. Populate secrets/hosts/linux.yaml with `sops -e -i` or fresh `sops`.
  #   4. Declare secrets under `sops.secrets.<name>` here.
  sops = {
    defaultSopsFile = ../../secrets/hosts/linux.yaml;

    # Activation-time decryption uses the host's SSH ed25519 key as the age
    # recipient. Unattended by design; humans edit with YubiKeys.
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # No secrets declared yet. Uncomment and populate once .sops.yaml has the
    # host recipient and secrets/hosts/linux.yaml is encrypted:
    #
    # secrets = {
    #   tailscale_authkey = { };
    # };
  };
}
