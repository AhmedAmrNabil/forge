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
    content = lib.mkOption {
      type = lib.types.str;
      default = lib.optionalString (config.path != null) (
        lib.removeSuffix "\n" (lib.readFile config.path)
      );
      defaultText = lib.literalExpression ''lib.optionalString (config.path != null) (lib.removeSuffix "\n" (lib.readFile config.path))'';
      description = "Data item content.";
    };
    path = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writeText config.name config.content;
      defaultText = lib.literalExpression "pkgs.writeText config.name config.content";
      description = "Data item absolute path.";
    };
  };
}
