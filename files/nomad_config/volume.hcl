client {
  host_volume "jobs" {
    path      = "/opt/nomad/jobs"
    read_only = true
  }
}