job "exec" {
  type        = "system"
  datacenters = ["dc1"]

  group "exec" {
    network {
      mode = "bridge"

      // ports
      port "http" {
        to = 80
      }
    }

    // services
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

    task "exec" {
      driver = "raw_exec"

      // artifacts
      artifact {
        source      = "https://github.com/grafana/loki/releases/download/v2.3.0/promtail-linux-amd64.zip"
        mode        = "file"
        destination = "local/promtail"
      }

      //templates
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
        // config
        command = "local/promtail"
        args    = ["-config.file=local/config.yaml"]
      }

      resources {
        // resources
        cpu    = 100
        memory = 256
      }
    }
  }
}