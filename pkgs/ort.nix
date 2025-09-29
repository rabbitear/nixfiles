import <nixpkgs> { overlays =
  [ (self: super: { }) ];
}.stdenv.mkDerivation {
#{ stdenv, cargo, rustc, clang }:
#stdenv.mkDerivation {
  name = "ort";
  src = builtins.fetchGit {
    url = "https://github.com/grahamking/ort";
    rev = "master"; # or your branch
  };
  #buildInputs = [ cargo rustc clang ];
  buildInputs = [ ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  buildPhase = "cargo build --release";
  installPhase = ''
  mkdir -p $out/bin cp target/release/ort $out/bin/ort '';
}
