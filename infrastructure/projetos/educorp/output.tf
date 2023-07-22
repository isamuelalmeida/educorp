output "efs_volume_ids" {
  value = { for k, v in local.customers.envs[terraform.workspace] : k => module.efs[k].id }
}

output "efs_mount_targets" {
  value = local.mount_targets
}