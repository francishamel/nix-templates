{
  description = "Elixir basic development environment.";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        elixir = pkgs.beam.packages.erlang.elixir;
        hex = pkgs.beam.packages.erlang.hex;
        locales = pkgs.glibcLocales;
        rebar3 = pkgs.beam.packages.erlang.rebar3;
      in {
        devShell = pkgs.mkShell {
          packages = [ elixir hex locales rebar3 ];

          ERL_AFLAGS =
            "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000";

          HEX_HOME = "./.cache/hex";

          MIX_HOME = "./.cache/mix";
          MIX_REBAR3 = "${rebar3}/bin/rebar3";
        };
      });
}
