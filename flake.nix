{
  description = "francishamel's flake templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, self }:
    let
      inherit (flake-utils.lib) defaultSystems eachSystemMap;
    in
    {
      legacyPackages = eachSystemMap defaultSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      templates = {
        elixir = {
          path = ./templates/elixir;
          description = "A flake for an elixir environment.";
        };
      };

      devShells = eachSystemMap defaultSystems (system:
        let
          pkgs = self.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil
              nixpkgs-fmt
            ];
          };
        }
      );
    };
}
