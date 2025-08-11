{
  description = "dotfiles flake";

  # 该 flake 不需任何外部依赖，仅用于在主 Flake 中暴露路径
  inputs = {};

  # 空 outputs 即可满足 Flake 要求
  outputs = { self, ... }: {};
}
