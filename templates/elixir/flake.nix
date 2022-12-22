{
  description = "Elixir basic development environment.";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        elixir = pkgs.beam.packages.erlang.elixir_1_14;
        elixir-ls = pkgs.beam.packages.erlang.elixir-ls;
        hex = pkgs.beam.packages.erlang.hex;
        locales = pkgs.glibcLocales;
        rebar3 = pkgs.beam.packages.erlang.rebar3;

        inherit (nixpkgs.lib) optional optionals;
        inherit (nixpkgs.stdenv) isDarwin isLinux;
      in
      {
        devShell = pkgs.mkShell {
          packages = [ elixir elixir-ls hex locales rebar3 ]
            ++ optional isLinux pkgs.inotify-tools
            ++ optional isDarwin pkgs.terminal-notifier
            ++ optionals isDarwin (with pkgs.darwin.apple_sdk.frameworks;
            [
              CoreFoundation
              CoreServices
            ]);

          shellHook = ''
            export MIX_HOME=$PWD/.cache/mix
            export HEX_HOME=$PWD/.cache/hex
            mkdir -p $MIX_HOME
            mkdir -p $HEX_HOME
            export PATH=$MIX_HOME/bin:$PATH
            export PATH=$HEX_HOME/bin:$PATH
          '';

          ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000";

          MIX_REBAR3 = "${rebar3}/bin/rebar3";
        };
      });
}
