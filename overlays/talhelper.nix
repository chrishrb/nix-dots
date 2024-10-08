inputs: _final: prev: {
  talhelper = inputs.talhelper.packages.${prev.system}.default;
}
