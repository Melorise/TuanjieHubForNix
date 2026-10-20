{
  lib,
  stdenvNoCC,
  libarchive,
  buildFHSEnv,
  makeFontsConf,
  fontconfig,
  noto-fonts-cjk-sans,
  corefonts,
  dejavu_fonts,
  liberation_ttf,
  src,
}:

let
  version = "1.4.7";
  editorFonts = [
    (noto-fonts-cjk-sans.override { static = true; })
    corefonts
    dejavu_fonts
    liberation_ttf
  ];
  fontsConf = makeFontsConf {
    fontDirectories = editorFonts;
    impureFontDirectories = [ ];
    includes = [ "${fontconfig.out}/etc/fonts/conf.d" ];
  };
  unpacked = stdenvNoCC.mkDerivation {
    pname = "tuanjiehub-unpacked";
    inherit version src;
    nativeBuildInputs = [ libarchive ];
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      bsdtar --extract --to-stdout --file "$src" data.tar.bz2 \
        | bsdtar --extract --file - --no-same-owner --directory "$out"
      runHook postInstall
    '';
  };
in
buildFHSEnv {
  pname = "tuanjiehub";
  inherit version;

  targetPkgs =
    pkgs: with pkgs; [
      libxrandr
      xdg-utils
      p7zip
      unzip
      gsettings-desktop-schemas
      hicolor-icon-theme
      fontconfig
      freetype
      lsb-release
    ] ++ editorFonts;

  multiPkgs =
    pkgs: with pkgs; [
      alsa-lib
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      icu
      libappindicator-gtk3
      libdrm
      libgbm
      libGL
      libnotify
      libsecret
      libuuid
      libx11
      libxcb
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxinerama
      libxkbcommon
      libxrandr
      libxrender
      libxshmfence
      libxscrnsaver
      libxtst
      nspr
      nss
      openssl
      pango
      stdenv.cc.cc.lib
      udev
      xdg-utils
      zlib
      lttng-ust_2_12
      krb5
      libva
      wayland
      cpio
      libpulseaudio
      libxml2_13
      clang
      git
      harfbuzz
      vulkan-loader
      libice
      libsm
    ];

  extraBuildCommands = ''
    mkdir -p "$out/opt"
    cp -a "${unpacked}/opt/". "$out/opt/"
    ln -s /opt/tuanjiehub/tuanjiehub "$out/usr/bin/tuanjiehub"
  '';

  runScript = "/opt/tuanjiehub/tuanjiehub";

  profile = ''
    export FONTCONFIG_FILE="${fontsConf}"
  '';

  extraInstallCommands = ''
    mkdir -p "$out/share"
    cp -a "${unpacked}/usr/share/". "$out/share/"
    substituteInPlace "$out/share/applications/tuanjiehub.desktop" \
      --replace-fail 'Exec=/opt/tuanjiehub/tuanjiehub %U' "Exec=$out/bin/tuanjiehub %U"
  '';

  meta = {
    description = "The official Tuanjie Hub";
    homepage = "https://tuanjie.cn/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "tuanjiehub";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
