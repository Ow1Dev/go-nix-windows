{
  description = "Example kickstart Go module project.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-windows" 
      ];

      perSystem = { config, self', inputs', pkgs, system, ... }: let
        name = "go-windows";  # Name of the package
        vendorHash = null;     # Update whenever go.mod changes

        pkgsCross = pkgs.pkgsCross;
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [just];
            inputsFrom = [self'.packages.x86_64-linux];
          };
        };

        packages = {
          # Default package for x86_64-linux
          x86_64-linux = pkgs.buildGoModule {
            inherit name vendorHash;
            src = ./.;  # The root of your Go module
            subPackages = ["cmd/go-windows"];  # Specify the subpackage with your hello.go
            meta = {
              description = "A Go application";
              platforms = [ "x86_64-linux" ];  # Define supported platforms here
            };
          };

          # Cross-compiled package for Windows
          
          x86_64-windows = (pkgsCross.mingwW64.buildGoModule {
            inherit name vendorHash;
            src = ./.;  # The root of your Go module
            subPackages = ["cmd/go-windows"];  # Specify the subpackage with your hello.go

            doCheck = system == "x86_64-linux";

            CGO_ENABLED = 0;

            ldflags = [
              "-s"  # Disable the generation of the DWARF symbol table
            ];

            meta = {
              description = "A cross-compiled Hello World application for Windows";
              platforms = [ "x86_64-windows" ];  # Define supported platforms here
            };
          }).overrideAttrs (old: old // { GOOS = "windows"; GOARCH = "amd64"; });
        };
      };
    };
}
