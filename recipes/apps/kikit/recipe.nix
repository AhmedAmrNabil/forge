{
  pkgs,
  ...
}:
let
  # TODO remove once https://github.com/NixOS/nixpkgs/pull/546237 is available in forge
  kikitFix = old: {
    postInstall = "";
    postPatch = (old.postPatch or "") + ''
      cat > kikit/_version.py <<'EOF'
      # DO NOT EDIT! nixpkgs GENERATED FILE
      import json

      version_json = ''''
      {
       "version": "${old.version}"
      }
      ''''  # END VERSION_JSON

      def get_versions():
          return json.loads(version_json)
      EOF
    '';
  };
  kikit = (pkgs.kikit.overridePythonAttrs kikitFix) // {
    override = args: (pkgs.kikit.override args).overridePythonAttrs kikitFix;
  };
  kicadAddons-kikit = pkgs.kicadAddons.kikit.override {
    inherit kikit;
  };
  kicadAddons-kikit-library = pkgs.kicadAddons.kikit-library.override {
    inherit kikit;
  };
in
{
  apps.kikit = {
    displayName = "KiKit";
    description = "Tooling for automation of production of PCB designed in KiCAD.";
    usage = ''
      KiKit is a Python library, KiCAD plugin, and a CLI tool to automate several tasks in a standard KiCAD workflow.

      Get started here https://yaqwsx.github.io/KiKit/latest/panelization/intro/.
    '';

    links = {
      website = "https://yaqwsx.github.io/KiKit/latest";
      docs = "https://yaqwsx.github.io/KiKit/latest/cli";
      source = "https://github.com/yaqwsx/KiKit";
    };

    ngi.grants = {
      Entrust = [ "KiKit" ];
    };

    icon = ./icon.svg;

    programs = {
      packages = [
        kikit
        kicadAddons-kikit
        kicadAddons-kikit-library
      ];
      runtimes.shell.enable = true;
    };

    test.programs.script = ''
      kikit --version | grep -q "${kikit.version}"
    '';
  };
}
