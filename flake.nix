{
  description = "Tuanjie Hub 1.4.7 repackaged from the official Debian release";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    tuanjiehub-deb = {
      url = "file+https://public-cdn.tuanjie.cn/hub/prod/tuanjiehub-amd64.deb";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, tuanjiehub-deb, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      hub = pkgs.callPackage ./package.nix { src = tuanjiehub-deb; };
    in
    {
      packages.${system} = {
        default = hub;
        tuanjiehub = hub;
      };
      apps.${system}.default = {
        type = "app";
        program = "${hub}/bin/tuanjiehub";
        meta.description = "Tuanjie Hub";
      };
      checks.${system}.tuanjiehub = hub;
      formatter.${system} = pkgs.nixfmt;
    };
}
