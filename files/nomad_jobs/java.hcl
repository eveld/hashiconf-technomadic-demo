job "minecraft" {
  datacenters = ["dc1"]

  group "minecraft" {
    count = 1

    network {
      mode = "bridge"

      port "server" {
        to = 25565
      }

      port "rcon" {
        to = 25575
      }
    }

    service {
      name = "minecraft-server"
      port = "25565"

      connect {
        sidecar_service {}
      }
    }

    service {
      name = "minecraft-rcon"
      port = "25575"

      connect {
        sidecar_service {}
      }
    }

    task "server" {
      driver = "java"
      user   = "root"

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/releases/download/v0.0.1/server.zip"
        destination = "/"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/releases/download/v0.0.1/mods.zip"
        destination = "/mods"
      }

      artifact {
        source      = "https://github.com/eveld/nomad-minecraft-server/releases/download/v0.0.1/world.zip"
        destination = "/"
      }

      template {
        destination = "/eula.txt"
        data        = <<EOF
        eula=true
        EOF
      }

      template {
        destination = "/server.properties"
        data        = <<EOF
        motd=HashiCraft
        level-name=Grimslade
        gamemode=creative
        difficulty=peaceful

        online-mode=false
        broadcast-console-to-ops=true
        spawn-monsters=false
        spawn-protection=0

        server-port=25565
        query.port=25565

        enable-rcon=true
        rcon.port=25575
        rcon.password=hashicraft
        
        enforce-whitelist=false
        white-list=false
        EOF
      }

      config {
        jar_path    = "/fabric-server-launch.jar"
        args        = ["nogui"]
        jvm_options = ["-Xmx2048m", "-Xms256m"]
      }

      resources {
        cpu    = 1000
        memory = 4096
      }
    }
  }
}