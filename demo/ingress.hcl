job "ingress" {
  type        = "system"
  datacenters = ["dc1"]

  group "ingress" {
    network {
      mode = "bridge"

      // ports
      port "minecraft-server" {
        static = 25565
        to     = 25565
      }

      port "minecraft-rcon" {
        static = 25575
        to     = 25575
      }

      port "qemu-vnc" {
        static = 8080
        to     = 8080
      }
    }

    // services
    service {
      name = "minecraft-ingress"

      connect {
        gateway {
          ingress {
            listener {
              port     = 25565
              protocol = "tcp"

              service {
                name = "minecraft-server"
              }
            }

            listener {
              port     = 25575
              protocol = "tcp"

              service {
                name = "minecraft-rcon"
              }
            }

            listener {
              port     = 8080
              protocol = "tcp"

              service {
                name = "qemu-vnc"
              }
            }
          }
        }
      }
    }
  }
}