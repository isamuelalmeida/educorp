resource "helm_release" "promtail" {
  depends_on = [helm_release.loki]

  atomic = true

  repository = "https://grafana.github.io/helm-charts"

  name    = "promtail"
  chart   = "promtail"
  version = "6.11.2"

  namespace = "grafana"

  timeout = 600

  values = [<<-EOT
      config:
        clients:
          - url: http://loki-distributor.grafana:3100/loki/api/v1/push
            external_labels:
              cluster: k8s-platos-${var.environment}
        snippets:
          pipelineStages:
            - docker: {}
            - multiline:
                # Identify zero-width space as first line of a multiline block.
                # Note the string should be in single quotes.
                firstline: '\x{200B}'
                max_wait_time: 3s
      resources:
        limits:
          cpu: 200m
          memory: 500Mi
        requests:
          cpu: 100m
          memory: 128Mi
      tolerations:
        - key: gitlab
          operator: Equal
          value: allowed
          effect: NoSchedule
        - key: educorp
          operator: Equal
          value: allowed

    EOT
  ]
}