{
  lib,
  ...
}:
{
  options = {
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of packages available in the test script.";
      example = lib.literalExpression "[ pkgs.curl pkgs.jq ]";
    };
    script = lib.mkOption {
      type = lib.types.str;
      default = ''
        echo "Test script"
      '';
      description = ''
        Script to test the package.
        The package being tested is available in PATH.

        Launch test with:

        ```
        nix build .#pkgs.''${package}.test
        ```
      '';
      example = ''
        hello | grep "Hello, world"
      '';
    };
  };
}
