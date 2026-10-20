# Tuanjie Hub For Nix

Tuanjie Hub 1.4.7，重打包自deb包

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


