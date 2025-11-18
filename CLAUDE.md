# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

这是一个基于 Nix Flakes 的个人系统配置仓库，主要支持 macOS (aarch64-darwin) 系统配置。使用 nix-darwin、home-manager 以及各种 dotfiles 来管理完整的系统环境。

## Architecture

### 核心结构
- `flake.nix` - 主要的 flake 入口文件，定义所有 inputs 和 outputs
- `outputs/` - 输出定义，使用 Haumea 进行模块化管理
  - `outputs/aarch64-darwin/` - macOS 系统配置
  - `outputs/shared.nix` - 共享的配置和参数
- `lib/` - 自定义库函数，包含系统构建 helpers
- `vars/` - 通用变量定义
- `modules/` - 模块化配置
  - `home-modules/` - home-manager 配置模块
  - `nixos-modules/` - NixOS/macOS 系统级模块
  - `pkgs/` - 自定义包定义
- `hosts/` - 具体主机配置文件
- `dotfiles/` - 应用程序配置文件

### 关键组件
- 使用 Haumea 进行模块自动加载和管理
- 支持多系统架构，目前主要使用 aarch64-darwin
- 集成 pre-commit hooks 进行代码质量检查
- 使用 overlays 系统进行包的自定义和补丁

## Common Development Commands

### 基本操作
```bash
# 查看所有可用命令
just

# 更新 flake inputs
just update

# 应用配置到当前系统
just rebuild

# 检查 flake 配置有效性
just check

# 格式化 Nix 代码
just lint

# 进入开发环境
just dev
```

### 系统管理
```bash
# 手动重建 Darwin 配置
sudo darwin-rebuild switch --flake ~/nix-config --show-trace

# 查看 flake 输出结构
nix flake show

# 检查系统当前安装的包
cat /etc/current-system-packages
```

### 开发环境
- 默认开发环境包含 `alejandra`、`deadnix`、`statix`、`typos`、`prettier` 等代码检查工具
- 配置了 pre-commit hooks 自动进行代码格式化和检查
- 使用 `nushell` 作为默认 shell

## Module System

### Home Manager 模块
- `modules/home-modules/darwin.nix` - macOS 特定的 home-manager 配置
- `modules/home-modules/global/` - 跨平台的通用配置
- `modules/home-modules/langs/` - 各种编程语言环境配置

### 系统级模块
- `modules/nixos-modules/darwin/` - macOS 系统级配置
- 包含 homebrew、proxy、sketchybar 等配置

### 自定义包
- `modules/pkgs/` 包含自定义的包定义
- 特别关注 Emacs 相关包和补丁

## Configuration Management

### 添加新主机
1. 在 `hosts/` 目录创建新的主机配置文件
2. 在 `outputs/aarch64-darwin/src/` 创建对应的系统定义文件
3. 确保主机名在各文件中保持一致

### 添加新的应用配置
1. 在 `dotfiles/` 目录添加配置文件
2. 在相应的 home-modules 中引用
3. 通过 flake inputs 管理外部配置源

### 代理设置
系统配置中包含代理设置（127.0.0.1:1081），在修改网络相关配置时需要注意。