nomad_cluster "dev" {
  version = "1.1.6-dev"
  client_nodes = 3

  network {
    name = "network.cloud"
  }
}