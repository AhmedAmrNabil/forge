{
  config,
  name,
  lib,
  pkgs,
  ...
}:
{
  options = {
    name = lib.mkOption {
      type = lib.types.str;
      default = name;
      description = ''
        Data item name.

        Defaults to the file's basename when sourced from a path, or to the
        attribute name otherwise.
      '';
    };
    isBinary = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether the data item is a binary file. Set to true for images/binaries to prevent Nix string evaluation errors.";
    };
    content = lib.mkOption {
      type = lib.types.str;
      default =
        # https://github.com/NixOS/nix/issues/1307
        if config.path != null && !config.isBinary then
          lib.removeSuffix "\n" (lib.readFile config.path)
        else
          "";
      defaultText = lib.literalExpression ''if config.path != null && !config.isBinary then lib.removeSuffix "\n" (lib.readFile config.path) else ""'';
      description = "Data item content. Will be an empty string for binary files as nix doesn't support reading binary files.";
    };
    path = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writeText config.name config.content;
      defaultText = lib.literalExpression "pkgs.writeText config.name config.content";
      description = "Data item absolute path.";
    };
  };
}
