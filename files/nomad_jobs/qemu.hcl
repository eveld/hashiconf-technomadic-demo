job "vm" {
  datacenters = ["dc1"]

  group "vm" {
    network {
      mode = "bridge"
    }

    task "vm" {
      driver = "qemu"

      artifact {
        source = "http://downloads.openwrt.org/releases/21.02.0/targets/lantiq/xway/openwrt-21.02.0-lantiq-xway-netgear_dgn3500-squashfs-factory.img"
      }

      config {
        image_path        = "local/openwrt-21.02.0-lantiq-xway-netgear_dgn3500-squashfs-factory.img"
        accelerator       = "kvm"
        graceful_shutdown = true
        args              = ["-nodefaults", "-nodefconfig"]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
