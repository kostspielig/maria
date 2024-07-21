{ pkgs ? import <nixpkgs> {} }:

let
  beam = pkgs.beam;
in
pkgs.mkShell {
  buildInputs = [
    beam.interpreters.erlang_25 # Erlang interpreter
    beam.packages.erlang_25.elixir_1_14 # Elixir 1.14
    pkgs.nodejs-18_x # Node.js, you can specify the version you need
    pkgs.inotify-tools # inotify-tools for file watching
    pkgs.wget # wget for fetching dependencies
    pkgs.postgresql # PostgreSQL client tools
    pkgs.rebar3 # Rebar3 build tool for Erlang projects
  ];

  shellHook = ''
    # Ensure mix is available in the shell
    export MIX_ENV=dev

    # Ensure that PostgreSQL binaries are available in the shell
    export PATH=${pkgs.postgresql}/bin:$PATH

    echo "Environment setup for Elixir 1.14 and Phoenix development"
  '';
}
