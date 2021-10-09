nomad_ingress "minecraft_server" {
  cluster = "nomad_cluster.dev"

  job   = "minecraft"
  group = "minecraft"
  task  = "server"

  port {
    local  = 25565
    remote = "minecraft"
    host   = 25565
  }

  network {
    name = "network.cloud"
  }
}

nomad_ingress "minecraft_rcon" {
  cluster = "nomad_cluster.dev"

  job   = "minecraft"
  group = "minecraft"
  task  = "server"

  port {
    local  = 25575
    remote = "rcon"
    host   = 25575
  }

  network {
    name = "network.cloud"
  }
}

nomad_ingress "vm" {
  cluster = "nomad_cluster.dev"

  job   = "vm"
  group = "vm"
  task  = "vm"

  port {
    local  = 5901
    remote = "vnc"
    host   = 5901
  }

  network {
    name = "network.cloud"
  }
}

nomad_ingress "grafana" {
  cluster = "nomad_cluster.dev"

  job   = "grafana"
  group = "grafana"
  task  = "grafana"

  port {
    local  = 3000
    remote = "http"
    host   = 3000
  }

  network {
    name = "network.cloud"
  }
}