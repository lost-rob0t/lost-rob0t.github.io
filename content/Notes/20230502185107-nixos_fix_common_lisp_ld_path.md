+++
title = "nixos fix common-lisp ld path"
draft = false
+++

## Fixing Common Lisp LD_LIBRARY_PATH {#fixing-common-lisp-ld-library-path}

If CL FFI can't see your library, such as OpenSSL, try building the path in the `shellHook`.
Example `flake.nix`[^fn:1] :

```nix
{
  description = "Flake ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShell.x86_64-linux =
      pkgs.mkShell {
        buildInputs = with pkgs; [
          pkg-config
          roswell
          sbcl
          openssl # NOTE Not sure if you need to include this
          # normally stuff goes in here
        ];
        shellHook = ''
              export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath([pkgs.openssl])}
            '';
      };
  };
}
```

More info: <https://archive.is/XvKqX>


## FootNotes {#footnotes}

[^fn:1]: <https://archive.is/Dor9q>
