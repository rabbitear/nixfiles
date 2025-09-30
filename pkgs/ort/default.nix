{ pkgs ? import <nixpkgs> { } }:

pkgs.buildGoModule rec {
  pname = "ort";
  version = "1.0.0"; # Upstream doesn’t seem to tag releases; update if needed

  src = pkgs.fetchFromGitHub {
    owner = "grahamking";
    repo = "ort";
    rev = "HEAD"; # you can pin to a commit hash for reproducibility
    #sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    sha256 = "ec8de7ddf1d17facee09836d4f2409f5ac611533";
  };

  vendorHash = null; # run `nix build` once to get the right value, it’ll tell you

  meta = with pkgs.lib; {
    description = "Command line tool that turns a file into a tree";
    homepage = "https://github.com/grahamking/ort";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
