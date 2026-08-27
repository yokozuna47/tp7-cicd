resource "kubernetes_namespace" "app" {
  metadata {
    name = "tf"
  }
}

resource "kubernetes_deployment" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "web"
      }
    }
    template {
      metadata {
        labels = {
          app = "web"
        }
      }
      spec {
        container {
          name  = "web"
          image = "nginxdemos/hello:plain-text"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name      = "web"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "web"
    }
    type = "NodePort"
    port {
      port        = 80
      target_port = 80
    }
  }
}
