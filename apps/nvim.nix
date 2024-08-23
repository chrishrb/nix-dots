{ system, inputs, ... }:
{
  type = "app";

  program = "${
    (import ../modules/common/nvim {
      inherit inputs;
    }).packages.${system}.default
  }/bin/chrisNvim";
}
