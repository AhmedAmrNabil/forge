{
  lib,
  service,
  serviceName,
}:
{
  ${serviceName} = {
    imports = [
      service.result
      {
        options.nimi = lib.mkOption {
          type = with lib.types; deferredModule;
          default = { };
          description = ''
            Let the modular service know that it's evaluated for nimi,
            by testing `options ? nimi`.
          '';
        };
        # HACK: nixpkgs recently added process.flagFormat with a functionTo type.
        # This results in a functor attrset that builtins.toJSON cannot serialize.
        # Since nimi blindly serializes the entire config to JSON, we must force
        # flagFormat to evaluate to null to prevent serialization errors.
        options.process.flagFormat = lib.mkOption {
          apply = _: null;
        };
      }
    ];
  };
}
