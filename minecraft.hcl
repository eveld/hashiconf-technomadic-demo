nomad_job "minecraft" {
  cluster = "nomad_cluster.dev"

  paths = ["files/nomad_jobs/minecraft.hcl"]
  health_check {
    timeout    = "120s"
    nomad_jobs = ["minecraft"]
  }
}

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