{
  description = "ORT Rust Project";
 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };
 
  outputs = { self, nixpkgs }: {
    packages = {
      x86_64-linux.default = (nixpkgs.legacyPackages.x86_64-linux.rustPlatform.buildRustPackage) {
        name = "ort";
        src = builtins.fetchGit {
          url = "https://github.com/grahamking/ort";
          rev = "master"; # Prefer a tag for reproducibility 
        };
        cargoLock = ./Cargo.lock;
        cargoBuildOptions = "--release"; # for optimized builds 
        homepage = "https://github.com/grahamking/ort";
        description = "A CLI client for OpenRouter.ai";
        license = nixpkgs.lib.licenses.mit; 
      };
    };
    defaultPackage.x86_64-linux = self.packages.x86_64-linux.default;
  };
}
