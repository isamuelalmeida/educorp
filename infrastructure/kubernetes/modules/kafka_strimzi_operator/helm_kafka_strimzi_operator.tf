resource "helm_release" "strimzi" {
  atomic = true

  name       = "strimzi"
  repository = "https://strimzi.io/charts"

  chart   = "strimzi-kafka-operator"
  version = "v0.30.0"

  namespace        = "kafka"
  create_namespace = true

  set {
    name  = "resources.limits.memory"
    value = var.strimzi_cluster_operator.resources.limits.memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.strimzi_cluster_operator.resources.limits.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.strimzi_cluster_operator.resources.requests.memory
  }

  set {
    name  = "resources.requests.cpu"
    value = var.strimzi_cluster_operator.resources.requests.cpu
  }

  set {
    name  = "nodeSelector.nodeTypeClass"
    value = "microservices"
  }

}