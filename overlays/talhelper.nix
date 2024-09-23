# INFO: these packages are buggy and don‘t work in unstable
inputs: _final: prev: {
  talhelper = inputs.talhelper.packages.${prev.system}.default;
}
