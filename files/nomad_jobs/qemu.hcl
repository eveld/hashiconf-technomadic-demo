job "vm" {
  datacenters = ["dc1"]

  group "vm" {
    network {
      mode = "bridge"

      port "vm" {
        to = 5901
      }

      port "vnc" {
        to = 8080
      }
    }

    service {
      name = "qemu-vnc"
      port = "8080"

      connect {
        sidecar_service {
          proxy {
            // This would be 10.0.2.2:25575 inside of the VM.
            upstreams {
              destination_name = "minecraft-rcon"
              local_bind_port  = 25575
            }
          }
        }
      }
    }

    task "vnc" {
      driver = "docker"

      env {
        NOVNC_PORT      = "8080"
        VNC_SERVER_IP   = "127.0.0.1"
        VNC_SERVER_PORT = "5901"
      }

      config {
        image = "voiselle/novnc"
        ports = ["vnc"]
      }
    }

    task "vm" {
      driver = "qemu"

      artifact {
        source = "http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-tinycore-linux-6.4-2.img"
        // source = "https://github.com/angrycub/nomad_example_jobs/raw/main/applications/vms/freedos/freedos.img.tgz"
      }

      artifact {
        source = "https://github.com/itzg/rcon-cli/releases/download/1.5.1/rcon-cli_1.5.1_linux_386.tar.gz"
      }

      config {
        accelerator = "kvm"
        image_path  = "local/linux-tinycore-linux-6.4-2.img"
        args = [
          "-vnc", ":1",
          "-device", "e1000,netdev=user.0",
          "-netdev", "user,id=user.0,dns=8.8.8.8"
        ]

        // image_path = "local/freedos.img"
        // args = [
        //   "-vnc", ":1",
        //   "-hdb", "fat:rw:/opt/qemu"
        // ]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}