nomad_job "grafana" {
  cluster = "nomad_cluster.dev"

  paths = ["files/nomad_jobs/grafana.hcl"]
  health_check {
    timeout    = "120s"
    nomad_jobs = ["grafana"]
  }
}

nomad_job "loki" {
  cluster = "nomad_cluster.dev"

  paths = ["files/nomad_jobs/loki.hcl"]
  health_check {
    timeout    = "120s"
    nomad_jobs = ["loki"]
  }
}

nomad_job "promtail" {
  cluster = "nomad_cluster.dev"

  paths = ["files/nomad_jobs/promtail.hcl"]
  health_check {
    timeout    = "120s"
    nomad_jobs = ["promtail"]
  }
}

nomad_ingress "grafana" {
  cluster = "nomad_cluster.dev"

  job   = "grafana"
  group = "grafana"
  task  = "grafana"

  port {
    local  = 3000
    remote = "http"
    host   = 3000
  }

  network {
    name = "network.cloud"
  }
}

nomad_ingress "loki" {
  cluster = "nomad_cluster.dev"

  job   = "loki"
  group = "loki"
  task  = "loki"

  port {
    local  = 3100
    remote = "logging"
    host   = 3100
  }

  network {
    name = "network.cloud"
  }
}