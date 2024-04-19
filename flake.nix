{
  description = "Simple program to add cover images to opus files";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        app = pkgs.python3Packages.buildPythonPackage {
          pname = "opusimage";
          version = "0.0.1";

          src = ./.;

          propagatedBuildInputs = [ pkgs.python3Packages.mutagen ];

          postInstall = ''
            mv "$out/bin/opusimage.py" "$out/bin/opusimage"
          '';
        };
      in
      {
        packages.default = app;
        packages.opusimage = app;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (pkgs.python3.withPackages (python-pkgs: [
                python-pkgs.mutagen
            ]))
          ];
        };
      }
    );
}
