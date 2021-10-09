container "vnc" {
  image {
    name = "voiselle/novnc"
  }

  network {
    name = "network.cloud"
  }

  env {
    key   = "NOVNC_PORT"
    value = "8080"
  }

  env {
    key   = "VNC_SERVER_IP"
    value = "vm.nomad-ingress.shipyard.run"
  }

  env {
    key   = "VNC_SERVER_PORT"
    value = "5901"
  }

  port {
    local  = 8080
    remote = 8080
    host   = 8080
  }
}