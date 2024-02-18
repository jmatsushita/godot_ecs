{
  description = "godot_ecs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs,... }@inputs:
    let
      name = "godot_ecs";

      supportedSystems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs { 
            inherit system;
          };

        in
        pkgs.mkShell {
          inherit name;
          # TODO: works on MacOS with official Godot install
          # adapt for other platforms
          GODOT4_BIN=(nixpkgs.lib.optionalString (system == "aarch64-darwin") "/Applications/Godot.app/Contents/MacOS/Godot");

          # TODO: test with wasm build
          # CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";
          # RUSTFLAGS="-C linker=lld";
          buildInputs = (with pkgs; [
            rustc
            cargo
            cargo-watch
            rust-analyzer
            # rustc-wasm32
            # llvmPackages.bintools
            # wasm-pack
          ]) ++ (pkgs.lib.optionals (system == "aarch64-darwin") (
            (with pkgs.darwin.apple_sdk.frameworks; [
              Cocoa
              CoreServices
              WebKit
              Security
            ]))
          );

        });
    };
}
