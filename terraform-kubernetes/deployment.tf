locals {
  json_data = jsondecode(file("${path.module}/applications.json"))
  size = length(local.json_data.applications[*])
}
resource "kubernetes_deployment" "deployments" {
    count = local.size
    metadata {
      name = local.json_data.applications[count.index].name
      labels = {
      app = local.json_data.applications[count.index].name
      }
    }
    spec {
    replicas = local.json_data.applications[count.index].replicas
    selector {
      match_labels = {
        app = local.json_data.applications[count.index].name
      }
    }
    template {
      metadata {
        labels = {
          app = local.json_data.applications[count.index].name
        }
      }
      spec {
        container {
          image = local.json_data.applications[count.index].image
          name  = local.json_data.applications[count.index].name
          port {
            container_port = local.json_data.applications[count.index].port
          }
          args = ["-listen=:${local.json_data.applications[count.index].port}","-text=\"I am ${local.json_data.applications[count.index].name}\""]
        }
      }
    }
    }
}
resource "kubernetes_service" "services" {
  count = local.size
  metadata {
    name = local.json_data.applications[count.index].name
  }
  spec {
    selector = {
      app = local.json_data.applications[count.index].name
    }
    session_affinity = "ClientIP"
    port {
      port        = local.json_data.applications[count.index].port
      target_port = local.json_data.applications[count.index].port
    }

    type = "ClusterIP"
  }
}
resource "kubernetes_ingress_v1" "first_ingress_rule" {
  depends_on = [kubernetes_deployment.deployments, kubernetes_service.services]
  metadata {
    name = local.json_data.applications[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          backend {
            service {
              name = local.json_data.applications[0].name
              port {
                number = local.json_data.applications[0].port
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }
      }
      host = "kalraandassociates.com"
    }
  }
}
resource "kubernetes_ingress_v1" "ingress_rules" {
  depends_on = [kubernetes_deployment.deployments, kubernetes_service.services]
  count = local.size - 1
  metadata {
    name = local.json_data.applications[count.index + 1].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/canary" = "true",
      "nginx.ingress.kubernetes.io/canary-weight" = local.json_data.applications[count.index + 1].traffic_weight
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          backend {
            service {
              name = local.json_data.applications[count.index + 1].name
              port {
                number = local.json_data.applications[count.index + 1].port
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }
      }
      host = "kalraandassociates.com"
    }
  }
}

/*
resource "time_sleep" "wait_30_seconds" {
  depends_on = [kubernetes_ingress_v1.blue-app-ingress]

  create_duration = "30s"
}


resource "kubernetes_ingress_v1" "green-app-ingress" {
  depends_on = [kubernetes_deployment.blue-app, kubernetes_deployment.green-app, kubernetes_service.green-app-service, kubernetes_service.blue-app-service]
  metadata {
    name = "green-app-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/canary" = "true",
      "nginx.ingress.kubernetes.io/canary-weight" = "25"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          backend {
            service {
              name = kubernetes_service.green-app-service.metadata.0.name
              port {
                number = 8081
              }
            }
          }
          path = "/"
          path_type = "Prefix"
        }
      }
      host = "kalraandassociates.com"
    }
  }
}
*/
