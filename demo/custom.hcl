job "custom" {
  datacenters = ["dc1"]

  group "custom" {


    task "custom" {
      driver = "minecraft"

      config {
        // config
        entity   = "minecart"
        position = "4562 60 5617"
      }

    }
  }
}