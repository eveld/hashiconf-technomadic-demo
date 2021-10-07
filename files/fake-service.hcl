job "fake" {
  datacenters = ["dc1"]
  type = "service"

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }
  
  group "fake_service" {
    count = 1

    network {
      port  "http" { 
        to = 9090
        static = 9090
      }
    }

    restart {
      # The number of attempts to run the job within the specified interval.
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    
    ephemeral_disk {
      size = 30
    }

    task "fake_service" {
      driver = "docker"

      template {
        data = <<EOF
        node_id = {{ env "node.unique.name" }}
        EOF
        destination   = "local/test.txt"

      }
      
      logs {
        max_files     = 2
        max_file_size = 10
      }

      env {
        LISTEN_ADDR = ":9090"
        NAME = "fake"
      }

      config {
        image = "nicholasjackson/fake-service:v0.18.1"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256

      }
    }
  }
}