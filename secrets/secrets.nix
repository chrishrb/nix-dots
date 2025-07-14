let
  mb-pro-cc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeJ7XePKz88X1J21wGvMqvwNmpMJ7GZaNwAb/NJmyVS";
  users = [ mb-pro-cc ];
in
{
  "github-secret.age".publicKeys = users;
}
