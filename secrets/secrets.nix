let
  mb-pro-cc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeJ7XePKz88X1J21wGvMqvwNmpMJ7GZaNwAb/NJmyVS";
  macbook-christoph = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMuRLtdx8jqwo0HD3ZYksr4MpeAZG38bgSQdixtj6hsC";
  users = [
    mb-pro-cc
    macbook-christoph
  ];
in
{
  "github.age".publicKeys = users;
  "gemini.age".publicKeys = users;
}
