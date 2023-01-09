{
  description = "Shipnix server configuration for ihp-npm-shipnix";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nix-npm-buildpackage = { url = "github:serokell/nix-npm-buildpackage"; };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-npm-buildpackage } @attrs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # use this variant if unfree packages are needed:
        # unstable = import nixpkgs-unstable {
        #  inherit system;
        #  config.allowUnfree = true;
        # };
      };
      nixPackages = nixpkgs.legacyPackages.${system};
      buildPackage = nixPackages.callPackage nix-npm-buildpackage { };
      nodeDependencies = buildPackage.mkNodeModules {
        # path to where the package-lock.json file is located
        src = ./.;
        pname = "npm";
        version = "8";
      };
      frontendAssets = nixPackages.stdenv.mkDerivation
        (
          {
            name = "frontend-assets";
            buildInputs = [ nixPackages.esbuild nixPackages.nodePackages_latest.tailwindcss ];
            src = ./frontend/.;
            # Build scripts for your bundled frontend assets
            installPhase = ''
              export NODE_ENV=production
              export NODE_PATH=${nodeDependencies}/node_modules
              export NODE_ENV=production
              export npm_config_cache=${nodeDependencies}/config-cache
              export BUNDLE_PATH=$out/frontend-assets 
              mkdir -p $BUNDLE_PATH
              esbuild $src/app.jsx --bundle --outfile=$BUNDLE_PATH/app.js --minify 
              # Navigating into the root project directory here so Tailwind gets to analyze the files with tailwind rules
              cd ${./.} && tailwindcss -c frontend/tailwind.config.js -o $BUNDLE_PATH/app.css --minify
            '';
          }
        );
    in
    {
      nixosConfigurations."ihp-npm-shipnix" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs // {
          environment = "production";
          frontendAssets = frontendAssets;
        };
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          ./nixos/configuration.nix
        ];
      };
    };
}
    