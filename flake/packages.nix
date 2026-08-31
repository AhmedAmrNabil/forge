{ forge-inputs, ... }:
{
  perSystem =
    {
      self',
      config,
      lib,
      pkgs,
      system,
      ...
    }:

    {
      legacyPackages = {
        elm-watch = pkgs.callPackage packages/elm-watch.nix { };
        elm2nix = pkgs.callPackage "${forge-inputs.elm2nix}/nix" {
          # TODO remove once https://github.com/dwayne/elm2nix/pull/5 is available
          elmVersion = pkgs.elmPackages.elm.version;
        };
      };
    };
}
