nomad_job "minecraft" {
  cluster = "nomad_cluster.dev"

  paths = ["files/minecraft.hcl"]
  health_check {
    timeout    = "120s"
    nomad_jobs = ["minecraft"]
  }
}