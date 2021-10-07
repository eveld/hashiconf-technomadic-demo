job "minecraft" {
    datacenters = ["dc1"]

    group "minecraft" {
        count = 1

        network {
            mode = "host"

            port "minecraft" {
                to = 25565
                static = 25565
            }

            port "rcon" {
                to = 25575
                static = 25575
            }
        }
        
        task "server" {
            driver = "java"

            template {
                destination = "/eula.txt"
                data = <<EOF
eula=true
EOF
            }

            template {
                perms = "666"
                destination = "/server.properties"
                source = "config/server.properties"
            }

            template {
                perms = "666"
                destination = "/whitelist.json"
                source = "config/whitelist.json"
            }

            template {
                perms = "666"
                destination = "/ops.json"
                source = "config/ops.json"
            }

            artifact {
                source = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/server.zip"
                destination = "/"
            }

            artifact {
                source = "https://github.com/eveld/nomad-minecraft-server/raw/main/files/mods.zip"
                destination = "/mods"
            }

            config {
                jar_path = "/fabric-server-launch.jar"
                args = ["nogui"]
                jvm_options = ["-Xmx2048m", "-Xms256m"]
            }

            resources {
                cpu = 100
                memory = 4096
            }
        }
    }
}
