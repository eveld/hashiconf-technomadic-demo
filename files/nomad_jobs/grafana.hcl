job "grafana" {
  datacenters = ["dc1"]

  group "grafana" {
    network {
      mode = "bridge"

      port "http" {
        to = 3000
      }
    }

    service {
      name = "grafana"
      port = "3000"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "loki"
              local_bind_port  = 3100
            }
          }
        }
      }
    }

    task "grafana" {
      driver = "docker"

      config {
        image = "grafana/grafana"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
