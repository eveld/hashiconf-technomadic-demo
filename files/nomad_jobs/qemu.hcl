job "vm" {
  datacenters = ["dc1"]

  group "vm" {
    network {
      mode = "host"

      port "vnc" {
        to     = 5901
        static = 5901
      }
    }

    task "vm" {
      driver = "qemu"

      artifact {
        source = "http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-tinycore-linux-6.4-2.img"
      }

      config {
        accelerator = "kvm"
        args = [
          "-vnc", ":1"
        ]
        image_path = "local/linux-tinycore-linux-6.4-2.img"
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}