job "loki" {
  datacenters = ["dc1"]

  group "loki" {
    network {
      mode = "bridge"

      port "logging" {
        to = 3100
      }
    }

    service {
      name = "loki"
      port = "3100"

      connect {
        sidecar_service {}
      }
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki"
        ports = ["logging"]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
