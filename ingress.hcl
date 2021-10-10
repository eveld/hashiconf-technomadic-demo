//
// Minecraft game endpoint.
//
nomad_ingress "minecraft_server" {
  cluster = "nomad_cluster.dev"

  job   = "ingress"
  group = "ingress"
  task  = ""

  port {
    local  = 25565
    remote = "minecraft-server"
    host   = 25565
  }

  network {
    name = "network.cloud"
  }
}

//
// Minecraft RCON endpoint.
//
nomad_ingress "minecraft_rcon" {
  cluster = "nomad_cluster.dev"

  job   = "ingress"
  group = "ingress"
  task  = ""

  port {
    local  = 25575
    remote = "minecraft-rcon"
    host   = 25575
  }

  network {
    name = "network.cloud"
  }
}

//
// QEMU vnc endpoint.
//
nomad_ingress "vm" {
  cluster = "nomad_cluster.dev"

  job   = "ingress"
  group = "ingress"
  task  = ""

  port {
    local  = 8080
    remote = "qemu-vnc"
    host   = 8080
  }

  network {
    name = "network.cloud"
  }
}

//
// Grafana endpoint.
//
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