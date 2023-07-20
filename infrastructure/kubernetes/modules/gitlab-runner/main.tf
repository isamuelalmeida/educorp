resource "helm_release" "gitlab_runner" {
  name       = "gitlab-runner"
  repository = "https://charts.gitlab.io"

  chart   = "gitlab-runner"
  version = "v0.50.0"

  namespace        = "gitlab-runner"
  create_namespace = true

  set {
    name  = "gitlabUrl"
    value = "https://gitlab.com/"
  }

  set {
    name  = "runnerRegistrationToken"
    value = data.aws_ssm_parameter.gitlab_runner_registration_token.value
  }

  set {
    name  = "runners.privileged"
    value = true
  }

  set {
    name  = "runners.namespace"
    value = "gitlab-runner"
  }

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "runners.tags"
    value = "self-runner"
  }

  set {
    name  = "runners.runUntagged"
    value = true
  }  

  set {
    name  = "runners.nodeSelector.nodeTypeClass"
    value = "gitlab"
  }

  set {
    name  = "nodeSelector.nodeTypeClass"
    value = "tools"
  }

  set {
    name  = "runners.nodeTolerations[0].key"
    value = "gitlab"
  }
  set {
    name  = "runners.nodeTolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "runners.nodeTolerations[0].value"
    value = "allowed"
  }
  set {
    name  = "runners.nodeTolerations[0].effect"
    value = "NoSchedule"
  }

  set {
    name  = "runners.builds.cpuRequests"
    value = "2000m"
  }

  set {
    name  = "resources.requests.cpu"
    value = "20m"
  }
  set {
    name  = "resources.limits.cpu"
    value = "100m"
  }
  set {
    name  = "resources.requests.memory"
    value = "50Mi"
  }
  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }
}