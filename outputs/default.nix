{ self
, nixpkgs
, pre-commit-hooks
, ...
}@inputs:

# ------------------------------------------------------------------
# Flake outputs/default.nix
# ------------------------------------------------------------------
# ① 利用 outputs/shared.nix 中的公共变量 (argDefaults 等)
# ② 保留仓库原有的 checks / devShell / packages 逻辑
# ③ 目前仅启用 aarch64-darwin 平台；其他系统目录可日后解注释

let
  inherit (nixpkgs) lib;
  
  # 自定义库 / 变量
  mylib  = import ../lib  { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # 公共 helper( overlays / argDefaults / common-modules … )
  # system 在此文件层面与平台无关, 先传 null, 其余地方按需覆盖
  shared = import ./shared.nix { inherit inputs; system = null; };
  
  # ---------------- 1. specialArgs 生成 -----------------------------
  genSpecialArgs = system: inputs // {
    inherit mylib myvars;

    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
      config.allowBroken = true;
    };
  };

  # Haumea 子模块会拿到的「通用参数包」
  baseArgs = shared.argDefaults // {
    inherit inputs lib mylib myvars genSpecialArgs;
  };

  # -------------- 2. 引入各系统子目录 ------------------------------
  nixosSystems  = {
    x86_64-linux  = import ./x86_64-linux  (baseArgs // { system = "x86_64-linux";  });
    # aarch64-linux = import ./aarch64-linux (baseArgs // { system = "aarch64-linux"; });
    # riscv64-linux = import ./riscv64-linux (baseArgs // { system = "riscv64-linux"; });
  };

  darwinSystems = {
    aarch64-darwin = import ./aarch64-darwin (baseArgs // { system = "aarch64-darwin"; });
    # x86_64-darwin = import ./x86_64-darwin (baseArgs // { system = "x86_64-darwin"; });
  };

  allSystems      = nixosSystems // darwinSystems;
  allSystemNames  = builtins.attrNames allSystems;
  nixosValues     = builtins.attrValues nixosSystems;
  darwinValues    = builtins.attrValues darwinSystems;
  allValues       = nixosValues ++ darwinValues;

  # 帮手：针对所有系统生成属性集
  forAllSystems = f: lib.genAttrs allSystemNames f;

in
{
  # ---------------------------------------------------------------
  # Debug 辅助
  # ---------------------------------------------------------------
  debugAttrs = {
    inherit nixosSystems darwinSystems allSystems allSystemNames;
  };

  # ---------------------------------------------------------------
  # 3. NixOS / Darwin 主机输出
  # ---------------------------------------------------------------
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (v: v.nixosConfigurations  or {}) nixosValues);

  darwinConfigurations =
    lib.attrsets.mergeAttrsList (map (v: v.darwinConfigurations or {}) darwinValues);

  # ---------------------------------------------------------------
  # 4. Colmena (仅 NixOS 主机)
  # ---------------------------------------------------------------
  colmena =
    {
      meta =
        let system = "x86_64-linux"; in
        {
          nixpkgs     = import nixpkgs { inherit system; };
          specialArgs = genSpecialArgs system;
        } // {
          nodeNixpkgs    = lib.attrsets.mergeAttrsList (map (v: v.colmenaMeta.nodeNixpkgs    or {}) nixosValues);
          nodeSpecialArgs= lib.attrsets.mergeAttrsList (map (v: v.colmenaMeta.nodeSpecialArgs or {}) nixosValues);
        };
    }
    // lib.attrsets.mergeAttrsList (map (v: v.colmena or {}) nixosValues);

  # ---------------------------------------------------------------
  # 5. Packages / Dev-shells / Formatter
  # ---------------------------------------------------------------
  packages = forAllSystems (system: allSystems.${system}.packages or {});

  devShells = forAllSystems (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      default = pkgs.mkShell {
        name = "dots";
        packages = with pkgs; [
          bashInteractive  # 修复 mkShell 非交互报错
          gcc              # 避免 nvim-treesitter 使用 clang 出错
          alejandra deadnix statix typos nodePackages.prettier
        ];
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
    }
  );

  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

  # ---------------------------------------------------------------
  # 6. Tests & CI Checks
  # ---------------------------------------------------------------
  evalTests = lib.lists.all (v: v.evalTests == {}) allValues;

  checks = forAllSystems (system: {
    eval-tests = (allSystems.${system}.evalTests or {}) == {};

    pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = mylib.relativeToRoot ".";
      hooks = {
        alejandra.enable = true;
        typos = {
          enable = true;
          settings = {
            write = true;
            configPath = "./.typos.toml";
          };
        };
        prettier = {
          enable = true;
          settings = {
            write = true;
            configPath = "./.prettierrc.yaml";
          };
        };
      };
    };
  });
}
