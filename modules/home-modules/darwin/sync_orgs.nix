{ inputs, ... }:

{
  home.file = {
    ".config/sync_orgs.sh".source = "${inputs.dotfiles}/sync_orgs.sh";
    # "Library/LaunchAgents/com.takaobsid.syncorgs.plist".source = "${inputs.dotfiles}/com.takaobsid.syncorgs.plist";
  };
}
