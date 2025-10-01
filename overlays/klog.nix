_: _final: prev: {
  klog-time-tracker = prev.klog-time-tracker.overrideAttrs (old: {
    nativeBuildInputs = with prev; [ installShellFiles go ];
    postInstall = ''
      installShellCompletion --cmd klog \
        --bash <($out/bin/klog completion -c bash) \
        --fish <($out/bin/klog completion -c fish) \
        --zsh <($out/bin/klog completion -c zsh)
    '';
  });
}
