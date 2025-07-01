{ config, pkgs, lib, ... }:

let
  # 引用路径是否为默认 emacs（匹配 store 名称）
  defaultEmacs = pkgs.emacs;
  isDefaultEmacs = builtins.match ".*-emacs-30\\.1.*" defaultEmacs.outPath != null;
in {
  assertions = [
    # {
    #   assertion = !isDefaultEmacs;
    #   message = ''
    #     ❌ 默认的 pkgs.emacs 被引用，当前是: ${defaultEmacs}
    #     建议你通过 overlay 或替换方式使用自定义 emacs（如 gtkEmacsMPS）
    #   '';
    # }
    {
      assertion = !(builtins.elem pkgs.emacs config.environment.systemPackages);
      message = ''
        ❌ environment.systemPackages 中包含默认 pkgs.emacs
        请移除它，或将其替换为自定义版本
      '';
    }
  ];
}
