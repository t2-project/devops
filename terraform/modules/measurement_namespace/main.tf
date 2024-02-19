resource "kubernetes_namespace" "measurement-namespace" {
  metadata {
    name = var.namespace_name
  }
}
