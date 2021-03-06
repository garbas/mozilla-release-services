{ releng_pkgs
}:
let
  inherit (builtins) readFile;
  inherit (releng_pkgs.lib) mkFrontend2;
  inherit (releng_pkgs.pkgs.lib) fileContents;

  nodejs = releng_pkgs.pkgs."nodejs-6_x";
  node_modules = import ./node-modules.nix {
    inherit nodejs;
    inherit (releng_pkgs) pkgs;
  };
  elm_packages = import ./elm-packages.nix;

in mkFrontend2 {
  inProduction = false;
  name = "mozilla-bzlite-frontend";
  inherit nodejs node_modules elm_packages;
  version = fileContents ./VERSION;
  src = ./.;
  postInstall = ''
    mkdir $out/static
    cp -R src/static/* $out/static/
  '';
}
