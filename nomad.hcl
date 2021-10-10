template "consul_agent_config" {
  source      = "${file("${file_dir()}/files/consul_config/agent.hcl")}"
  destination = "${data("consul_config")}/agent.hcl"
}

nomad_cluster "dev" {
  version      = "1.1.6"
  client_nodes = 3

  consul_config = "${data("consul_config")}/agent.hcl"

  network {
    name = "network.cloud"
  }

  volume {
    source      = "${file_dir()}/files/nomad_config/allow.hcl"
    destination = "/etc/nomad.d/allow.hcl"
  }

  volume {
    source      = "${file_dir()}/files/nomad_config/plugin.hcl"
    destination = "/etc/nomad.d/plugin.hcl"
  }

  volume {
    source      = "${file_dir()}/files/nomad_plugins/minecraft"
    destination = "/var/lib/nomad/plugins/minecraft"
  }

  volume {
    source      = "${file_dir()}/files/qemu"
    destination = "/opt/qemu"
  }
}

output "NOMAD_ADDR" {
  value = cluster_api("nomad_cluster.dev")
}