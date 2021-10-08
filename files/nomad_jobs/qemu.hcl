job "vm" {
  datacenters = ["dc1"]

  group "vm" {
    network {
      mode = "bridge"
    }

    task "vm" {
      driver = "qemu"

      artifact {
        source = "http://downloads.sourceforge.net/project/gns-3/Qemu%20Appliances/linux-tinycore-linux-6.4-2.img"
      }

      config {
        image_path        = "local/linux-tinycore-linux-6.4-2.img"
        accelerator       = "kvm"
        graceful_shutdown = true
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
