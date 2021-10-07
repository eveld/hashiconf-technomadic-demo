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

        task "installer" {
            driver = "java"

            lifecycle {
                hook = "prestart"
                sidecar = false
            }

            artifact {
                source = "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.8.0/fabric-installer-0.8.0.jar"
                destination = "/alloc/"
            }

            config {
                jar_path = "/alloc/fabric-installer-0.8.0.jar"
                args = ["server", "-downloadMinecraft", "-dir", "/", "-mcversion", "1.17.1"]
                jvm_options = ["-Xmx2048m", "-Xms256m"]
            }

            resources {
                cpu = 100
                memory = 2048
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

            // artifact {
            //     source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
            //     destination = "/"
            // }

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
