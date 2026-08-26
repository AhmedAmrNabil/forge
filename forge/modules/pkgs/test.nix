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
    runner = lib.mkOption {
      type = lib.types.enum [
        "bash"
        "nixos"
      ];
      default = "bash";
      description = ''
        Type of runner to execute the script.

        When using the `nixos` VM runner, you can pass extra configurations
        using the `test.nixosModules` option.
      '';
    };
    nixosConfig = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
      description = ''
        Extra configuration passed to the NixOS VM running the test.

        See the list of available
        [NixOS options](https://search.nixos.org/options) .
      '';
      example = lib.literalExpression ''
        {
          virtualisation.memorySize = 4096;
          virtualisation.diskSize = 10240;
        }
      '';
    };
  };
}
