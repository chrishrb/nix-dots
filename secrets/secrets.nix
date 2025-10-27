let
  macbook-christoph = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMuRLtdx8jqwo0HD3ZYksr4MpeAZG38bgSQdixtj6hsC";
  macbook-gipedo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBH34wOE+ji83sY483B8Qgi6B64bmSwcVa1smhVHFT39";

  users = [
    macbook-gipedo
    macbook-christoph
  ];
in
{
  "github.age".publicKeys = users;
  "gemini.age".publicKeys = users;
  "context7.age".publicKeys = users;
  "grafana.age".publicKeys = users;
}
