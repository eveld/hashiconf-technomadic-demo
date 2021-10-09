nomad_job "minecraft" {
  cluster = "nomad_cluster.dev"

  paths = ["files/nomad_jobs/minecraft.hcl"]
  health_check {
    timeout    = "300s"
    nomad_jobs = ["minecraft"]
  }
}