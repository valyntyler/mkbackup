{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            self.packages.${system}.default
            just
            nushell
            ouch
          ];
        };
        packages = rec {
          default = mkbackup;
          mkbackup = pkgs.stdenv.mkDerivation rec {
            name = "mkbackup";
            src = ./src;
            buildInputs = with pkgs; [makeWrapper];
            installPhase = ''
              mkdir -p $out/bin
              cp ./main.nu $out/bin/${name}
              chmod +x $out/bin/${name}
              wrapProgram $out/bin/${name} \
                --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
                nushell
                ouch
              ])}
            '';
          };
        };
      }
    );
}
