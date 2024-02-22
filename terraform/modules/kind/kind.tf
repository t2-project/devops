resource "kind_cluster" "kind_cluster" {
  name            = "kind"
  kubeconfig_path = pathexpand(var.kube_config)

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
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
  count = var.set_kubecfg ? 1 : 0

  provisioner "local-exec" {
    command = "kind export kubeconfig"
  }

  depends_on = [kind_cluster.kind_cluster]
}
