job "exec" {
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
      mode = "bridge"
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
      driver = "exec"

      config {
        command = "tail -f /dev/null"
      }

      logs {
        max_files     = 2
        max_file_size = 10
      }

      resources {
        cpu    = 500
        memory = 256

      }
    }
  }
}