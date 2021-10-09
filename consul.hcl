template "consul_server_config" {
  source      = "${file("${file_dir()}/files/consul_config/server.hcl")}"
  destination = "${data("consul_config")}/server.hcl"
}

container "consul" {
  depends_on = ["template.consul_server_config"]

  image {
    name = "consul:1.10.3"
  }

  command = ["consul", "agent", "-config-file=/config/server.hcl"]

  volume {
    source      = "${data("consul_config")}/server.hcl"
    destination = "/config/server.hcl"
  }

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
  }
}