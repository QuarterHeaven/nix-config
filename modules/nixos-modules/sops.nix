{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # sops.gnupg.home = "/home/takaobsid/.gnupg";
  # sops.gnupg.sshKeyPaths = [];

  sops.defaultSopsFile = "${inputs.dotfiles}/secrets/secrets.yaml";

  # If you use something different from YAML, you can also specify it here:
  sops.defaultSopsFormat = "yaml";
  sops.secrets.github_token = {
    # The sops file can be also overwritten per secret...
    sopsFile = "${inputs.dotfiles}/secrets/secrets.yaml";
    # ... as well as the format
    format = "yaml";

    owner = "takaobsid";
    group = "users";
  };
}
