resource "kind_cluster" "kind_cluster" {
  name            = "kind"
  kubeconfig_path = pathexpand(var.kube_config)
  count           = var.create_module ? 1 : 0

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"

      # workaround for WSL2: https://kind.sigs.k8s.io/docs/user/using-wsl2/#accessing-a-kubernetes-service-running-in-wsl2
      extra_port_mappings {
        container_port = 30000
        host_port      = 30000
      }
    }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}

resource "null_resource" "kind" {
  count = var.create_module && var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command = "kind export kubeconfig"
  }

  depends_on = [kind_cluster.kind_cluster]
}
