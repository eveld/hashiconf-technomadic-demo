job "minecraft" {
    datacenters = ["dc1"]

    group "minecraft" {
        count = 1

        network {
            mode = "bridge"

            dns {
                servers = ["8.8.8.8"]
            }

            port "minecraft" {
                to = 25565
                static = 25565
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
                memory = 2048
            }
        }
    }
}
