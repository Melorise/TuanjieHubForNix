# Tuanjie Hub For Nix

Tuanjie Hub 1.4.7，重打包自deb包

使用 FHS 环境运行 Hub 及其安装的编辑器，包含 nixpkgs Unity Hub 打包所列的编辑器、授权服务、Bug Reporter、字体和辅助工具依赖。`libxml2_13` 提供编辑器需要的 `libxml2.so.2`。

Hub 及其启动的编辑器通过独立的 `FONTCONFIG_FILE` 使用静态版 Noto Sans CJK、Core Fonts、DejaVu 和 Liberation 字体，为编辑器内部中文界面提供字体回退。更新软件包后，关闭编辑器和 Hub，再通过 `nix run` 启动。

## 使用

```sh
nix build
nix run
```

安装到用户环境：

```sh
nix profile add .#tuanjiehub
```

软件包提供 `tuanjiehub` 命令、应用菜单条目、图标和 `tuanjiehub://` 协议关联。在 NixOS 或 Home Manager 配置中，将此项目作为 flake 输入，并将 `inputs.tuanjiehub.packages.x86_64-linux.default` 加入 `environment.systemPackages` 或 `home.packages`。


