# run test window
r:
  nixGLMesa cabal v2-repl src/main.hs 
# reload dev environment
d:
  direnv reload
# build executable
b:
  nix build
