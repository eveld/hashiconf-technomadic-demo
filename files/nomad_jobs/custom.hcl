job "minecart" {
  datacenters = ["dc1"]
  type        = "service"

  group "minecart" {
    task "minecart" {
      driver = "minecraft"

      config {
        // entity = "chest_minecart"
        // entity = "tnt_minecart"
        // entity = "hopper_minecart"
        entity   = "minecart"
        position = "x y z"
      }
    }
  }
}
