job "promtail" {
  datacenters = ["dc1"]

  type = "system"

  group "promtail" {
    network {
      mode = "bridge"

      port "http" {
        to = 80
      }
    }

    service {
      name = "promtail"
      port = "80"

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

    task "scraper" {
      driver = "raw_exec"

      artifact {
        source      = "https://github.com/grafana/loki/releases/download/v2.3.0/promtail-linux-amd64.zip"
        mode        = "file"
        destination = "local/promtail"
      }

      template {
        destination = "local/config.yaml"
        data        = <<EOF
positions:
  filename: /tmp/positions.yaml

client:
  url: http://localhost:3100/loki/api/v1/push

scrape_configs:
- job_name: system
  static_configs:
  - targets:
    - localhost
    labels:
      job: varlogs
      host: yourhost
      __path__: /var/lib/nomad/alloc/*/alloc/logs/*.0
EOF
      }

      config {
        command = "local/promtail"
        args    = ["-config.file=local/config.yaml"]
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}