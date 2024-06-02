{
  description = "Simple program to add tags and cover image to opus file";

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

        version = pkgs.lib.strings.fileContents "${self}/version";
        fullVersion = ''${version}-${self.dirtyShortRev or self.shortRev or "dirty"}'';

        app = pkgs.python3Packages.buildPythonPackage {
          pname = "tagopus";
          version = fullVersion;

          src = ./.;

          propagatedBuildInputs = [ pkgs.python3Packages.mutagen ];

          postInstall = ''
            mv "$out/bin/tagopus.py" "$out/bin/tagopus"
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
