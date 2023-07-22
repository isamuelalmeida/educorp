locals {
  envs = {
    default = {
      region = "us-east-1"
    }

    dev = {
      environment     = "dev"
      account_id      = "638081184541"
      region          = "us-east-1"
      domain          = "dev.educorp.app"
      certificate_arn = ""

      vpc = {
        vpc_name         = "cognalabs-dev"
        azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets  = ["10.211.8.0/24", "10.211.9.0/24", "10.211.10.0/24"]
        public_subnets   = ["10.211.11.0/26", "10.211.11.64/26", "10.211.11.128/26"]
        database_subnets = ["10.211.11.192/28", "10.211.11.208/28", "10.211.11.224/28"]
        cidr             = "10.211.8.0/22"
      }

      eks = {
        cluster_name    = "cognalabs-dev"
        cluster_version = "1.24"

        aws_auth_users = [
          {
            userarn  = "arn:aws:iam::638081184541:role/AWSReservedSSO_Operator_Access_efd4f25f68661910"
            username = "*"
            groups   = ["system:masters"]
          }
        ]

        aws_auth_roles = [
          {
            rolearn  = "arn:aws:iam::638081184541:role/cognalabs-dev-initial-eks-node-group-20230722002036531600000001"
            username = "system:node:{{EC2PrivateDNSName}}"
            groups   = ["system:bootstrappers", "system:nodes"]
          }
        ]

        node_group_initial = {
          min_size       = 1
          max_size       = 3
          desired_size   = 1
          disk_size      = 30
          instance_types = ["t3a.medium"]
          ami_type       = "AL2_x86_64"
          capacity_type  = "ON_DEMAND"
          labels = {
            nodeTypeClass = "initial"
          }
        }

        karpenter = {
          replicas = 1
          resources = {
            requests = {
              cpu = "1500m"
              memory = "3Gi"
            }
            limits = {
              cpu = "1500m"
              memory = "3Gi"
            }
          }         

          default = {
            provisioner = {
              requirements = {
                os                  = ["linux"]
                instance_hypervisor = ["nitro"]
                arch                = ["amd64"]
                capacity_type       = ["spot"]
                instance_family     = ["m6a", "t3a", "c6a"]
                instance_cpu        = ["2", "4", "8"]
              }
              limits = {
                cpu    = "16"
                memory = "64Gi"
              }
              ttl_seconds_after_empty = 30
            }
            node_template = {
              device_name = "/dev/xvda"
              volume_size = "20Gi"
              volume_type = "gp3"
              encrypted   = true
            }
          }
        }
      }

      aws_provider_role_arn = "arn:aws:iam::638081184541:role/OrganizarionAccountAccessRole"
    }

    production = {
      environment     = "production"
      account_id      = "583181080694"
      region          = "us-east-1"
      domain          = "educorp.app"
      certificate_arn = ""

      vpc = {
        vpc_name         = "cognalabs-prd"
        azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets  = ["10.200.0.0/22", "10.200.4.0/22", "10.200.8.0/22"]
        public_subnets   = ["10.200.12.0/24", "10.200.13.0/24", "10.200.14.0/24"]
        database_subnets = ["10.200.15.0/26", "10.200.15.64/26", "10.200.15.128/26"]
        cidr             = "10.224.0.0/20"
      }

      eks = {
        cluster_name    = "cognalabs-prd"
        cluster_version = "1.24"

        aws_auth_users = [
          {
            userarn  = "arn:aws:iam::583181080694:role/AWSReservedSSO_Operator_Access_3cc672357dc5c5a8"
            username = "*"
            groups   = ["system:masters"]
          }
        ]

        aws_auth_roles = [
          {
            rolearn  = "arn:aws:iam::583181080694:role/cosmos-eks-prd-initial-eks-node-group-20230706191607446100000002"
            username = "system:node:{{EC2PrivateDNSName}}"
            groups   = ["system:bootstrappers", "system:nodes"]
          }
        ]

        node_group_initial = {
          min_size       = 2
          max_size       = 3
          desired_size   = 2
          disk_size      = 30
          instance_types = ["t3a.medium"]
          ami_type       = "AL2_x86_64"
          capacity_type  = "ON_DEMAND"
          labels = {
            nodeTypeClass = "initial"
          }
        }

        karpenter = {
          replicas = 2
          resources = {
            requests = {
              cpu = "1000m"
              memory = "2Gi"
            }
            limits = {
              cpu = "1000m"
              memory = "2Gi"
            }
          }          

          default = {
            provisioner = {
              requirements = {
                os                  = ["linux"]
                instance_hypervisor = ["nitro"]
                arch                = ["amd64"]
                capacity_type       = ["on-demand"]
                instance_family     = ["m6a", "t3a", "c6a"]
                instance_cpu        = ["4"]
              }
              limits = {
                cpu    = "16"
                memory = "64Gi"
              }
              ttl_seconds_after_empty = 30
            }
            node_template = {
              device_name = "/dev/xvda"
              volume_size = "20Gi"
              volume_type = "gp3"
              encrypted   = true
            }
          }
        }
      
      }      

      aws_provider_role_arn = "arn:aws:iam::583181080694:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Operator_Access_4c61badad3d1f3d3"
    }

    alb = {
      ingress = {
        group_orders = {
          www                   = "1"          
        }
      }
    }

    default_tags = {
      "conjunto-orcamentario" = "431082276051320606200323"
      "contato-gestor"        = "nome@educorp.app"
      "contato-tecnico"       = "nome@educorp.app"
      "cadeia-valor"          = "Cogna Labs"
      "sn-produto"            = "CognaLabs"
      "sn-modulo"             = "CognaLabs"
      "iac"                   = "Terraform"
      "repo"                  = "https://gitlab.com/platosedu/cosmos/devops/infra-platos"
    }
    default_tag_estagio_by_env = {
      "default"    = "PRD"
      "dev"        = "DEV"
      "production" = "PRD"
    }
    aws_role_arn_by_env = {
      "default"    = "arn:aws:iam::583181080694:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Operator_Access_4c61badad3d1f3d3"
      "dev"        = "arn:aws:iam::638081184541:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Operator_Access_efd4f25f68661910"
      "production" = "arn:aws:iam::583181080694:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Operator_Access_4c61badad3d1f3d3"
    }
  }
}