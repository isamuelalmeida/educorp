resource "aws_kms_key" "vault_kms_unseal_key" {
  description             = "Chave utilizada para destravar o cofre do Hashicorp Vault automaticamente"
  deletion_window_in_days = 10
  enable_key_rotation     = false
  policy = jsonencode(
    {
      "Id"      = "key-consolepolicy-3",
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"    = "Enable IAM User Permissions",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = module.env_info.envs[terraform.workspace].aws_provider_role_arn
          },
          "Action"   = "kms:*",
          "Resource" = "*"
        },
        {
          "Sid"    = "Allow access for Key Administrators",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = [
              module.env_info.envs[terraform.workspace].aws_provider_role_arn,
              local.arn_account_id_by_env[terraform.workspace],
              module.env_info.envs.aws_role_arn_by_env[terraform.workspace]
            ]
          },
          "Action" = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
          ],
          "Resource" = "*"
        },
        {
          "Sid"    = "Allow use of the key",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = [
              module.env_info.envs[terraform.workspace].aws_provider_role_arn,
              local.arn_account_id_by_env[terraform.workspace],
              module.env_info.envs.aws_role_arn_by_env[terraform.workspace]
            ]
          },
          "Action" = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" = "*"
        },
        {
          "Sid"    = "Allow attachment of persistent resources",
          "Effect" = "Allow",
          "Principal" = {
            "AWS" = [
              module.env_info.envs[terraform.workspace].aws_provider_role_arn,
              local.arn_account_id_by_env[terraform.workspace],
              module.env_info.envs.aws_role_arn_by_env[terraform.workspace]
            ]
          },
          "Action" = [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
          ],
          "Resource" = "*",
          "Condition" = {
            "Bool" = {
              "kms:GrantIsForAWSResource" = "true"
            }
          }
        }
      ]
    }
  )
}

locals {
  kms_alias_by_env = {
    "dev"        = "alias/vault-unseal-key-dev"
    "stage"      = "alias/vault-unseal-key-stage-v2"
    "production" = "alias/vault-unseal-key-production"
  }

  arn_account_id_by_env = {
    "dev"        = "arn:aws:iam::703669458031:user/cosmos"
    "stage"      = "arn:aws:iam::703669458031:user/cosmos"
    "production" = "arn:aws:iam::200535794330:user/cosmos"
  }
}

resource "aws_kms_alias" "vault_kms_unseal_key_alias" {
  name          = local.kms_alias_by_env[terraform.workspace]
  target_key_id = aws_kms_key.vault_kms_unseal_key.key_id
}