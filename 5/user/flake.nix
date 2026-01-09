{
  description = "Node.js secp256k1 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "node-secp256k1-shell";

          packages = with pkgs; [
            nodejs_20
            nodePackages.npm
            nodePackages.pnpm
            nodePackages.yarn
          ];

          shellHook = ''
            echo "🔐 Node.js secp256k1 dev shell"
            echo "Node version: $(node --version)"
          '';
        };
      }
    );
}
