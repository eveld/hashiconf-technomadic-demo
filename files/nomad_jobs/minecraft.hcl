job "minecraft" {
  datacenters = ["dc1"]

  group "minecraft" {
    count = 1

    network {
      mode = "host"

      port "minecraft" {
        to     = 25565
        static = 25565
      }

      port "rcon" {
        to     = 25575
        static = 25575
      }
    }

    service {
      name = "minecraft"
      port = "25565"
    }

    service {
      name = "rcon"
      port = "25575"
    }

    task "server" {
      driver = "java"

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/nomad_jobs/config/eula.txt"
        destination = "/"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/nomad_jobs/config/server.properties"
        destination = "/"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/server.zip"
        destination = "/"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/mods.zip"
        destination = "/mods"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/world.zip"
        destination = "/"
      }

      config {
        jar_path    = "/fabric-server-launch.jar"
        args        = ["nogui"]
        jvm_options = ["-Xmx2048m", "-Xms256m"]
      }

      resources {
        cpu    = 100
        memory = 4096
      }
    }
  }
}


