# 3

# Nodegroup educorp
resource "kubectl_manifest" "karpenter_provisioner_default" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-default
    spec:
      requirements:
        - key: kubernetes.io/os
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.os)}
        - key: karpenter.k8s.aws/instance-hypervisor
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.instance_hypervisor)}
        - key: kubernetes.io/arch
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.arch)}
        - key: karpenter.sh/capacity-type
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.capacity_type)}
        - key: karpenter.k8s.aws/instance-family
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.instance_family)}
        - key: karpenter.k8s.aws/instance-cpu
          operator: In
          values: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.requirements.instance_cpu)}
      limits:
        resources:
          cpu: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.limits.cpu)}
          memory: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.limits.memory)}
      providerRef:
        name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-default
      ttlSecondsAfterEmpty: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.provisioner.ttl_seconds_after_empty)}

  YAML
}

resource "kubectl_manifest" "karpenter_node_template_default" {
  depends_on = [helm_release.karpenter]

  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: ${module.env_info.envs[terraform.workspace].eks.cluster_name}-default
    spec:
      blockDeviceMappings:
        - deviceName: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.node_template.device_name)}
          ebs:
            volumeSize: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.node_template.volume_size)}
            volumeType: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.node_template.volume_type)}
            encrypted: ${jsonencode(module.env_info.envs[terraform.workspace].eks.karpenter.default.node_template.encrypted)}
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