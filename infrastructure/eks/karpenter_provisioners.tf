# 3
# Nodegroup microservices
resource "kubectl_manifest" "karpenter_provisioner_microservices" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mcs
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-memory
          operator: Gt
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.instance_memory)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mcs
      consolidation:
        enabled: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.provisioner.consolidation)}
      labels:
        nodeTypeClass: microservices
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_microservices" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mcs
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.microservices.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: platos
  YAML
}

# Nodegroup monolith
resource "kubectl_manifest" "karpenter_provisioner_monolith" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mon
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mon
      consolidation:
        enabled: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.provisioner.consolidation)}
      labels:
        nodeTypeClass: monolith
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_monolith" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-mon
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.monolith.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: platos
  YAML
}

# Nodegroup tools
resource "kubectl_manifest" "karpenter_provisioner_tools" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-tools
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-tools
      consolidation:
        enabled: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.provisioner.consolidation)}
      labels:
        nodeTypeClass: tools
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_tools" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-tools
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.tools.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: platos
  YAML
}

# Nodegroup observability
resource "kubectl_manifest" "karpenter_provisioner_observability" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-obs
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-obs
      consolidation:
        enabled: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.provisioner.consolidation)}
      labels:
        nodeTypeClass: observability
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_observability" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-obs
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.observability.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: platos
  YAML
}

# Nodegroup gitlab
resource "kubectl_manifest" "karpenter_provisioner_gitlab" {
  depends_on = [helm_release.karpenter]

  count = contains(["dev"], terraform.workspace) ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-runner
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.requirements.capacity_type)}
        - key: node.kubernetes.io/instance-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.requirements.instance_type)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-runner
      ttlSecondsAfterEmpty: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.provisioner.ttl_seconds_after_empty)}
      labels:
        nodeTypeClass: gitlab
      taints:
      - key: gitlab
        value: "allowed"
        effect: NoSchedule
      weight: 10
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_gitlab" {
  depends_on = [helm_release.karpenter]

  count = contains(["dev"], terraform.workspace) ? 1 : 0

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-runner
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.gitlab_runner.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: platos
  YAML
}

# Nodegroup educorp
resource "kubectl_manifest" "karpenter_provisioner_educorp" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-educorp
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-educorp
      ttlSecondsAfterEmpty: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.provisioner.ttl_seconds_after_empty)}
      labels:
        nodeTypeClass: educorp
      taints:
      - key: educorp
        value: "allowed"
        effect: NoSchedule
  YAML
}

resource "kubectl_manifest" "karpenter_node_template_educorp" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-educorp
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.educorp.node_template.encrypted)}
      subnetSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      securityGroupSelector:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.env_info.envs[terraform.workspace].eks.cluster_name}
        estagio: ${module.env_info.envs.default_tag_estagio_by_env[terraform.workspace]}
        sn-produto: educorp
  YAML
}