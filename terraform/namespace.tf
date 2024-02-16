resource "kubernetes_namespace" "measurement-namespace" {
  metadata {
    name = var.measurement-namespace
  }

  depends_on = [module.kind, module.eks]
}

# resource "kubernetes_namespace" "app-namespace" {
#   metadata {
#     name = var.app-namespace
#   }

#   depends_on = [module.kind, module.eks]
# }
