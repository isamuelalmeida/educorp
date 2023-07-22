locals {
  customers = {
    envs = {
      dev = {
        "eco" = {
          rds = {
            identifier                   = "educorp-eco-dev"
            db_instance_class            = "db.t4g.micro"
            performance_insights_enabled = false
            skip_final_snapshot          = true
          }
          efs = {
            performance_mode                = "generalPurpose"
            throughput_mode                 = "bursting"
            provisioned_throughput_in_mibps = null
          }
        }
      },      
      production = {
        "callink" = {
          rds = {
            identifier                   = "educorp-callink-prod"
            db_instance_class            = "db.t4g.medium"
            performance_insights_enabled = false
            skip_final_snapshot          = false
          }
          efs = {
            performance_mode                = "generalPurpose"
            throughput_mode                 = "bursting"
            provisioned_throughput_in_mibps = null
          }
        },
        "cogna" = {
          rds = {
            identifier                   = "educorp-cogna-prod"
            db_instance_class            = "db.t4g.medium"
            performance_insights_enabled = false
            skip_final_snapshot          = false
          }
          efs = {
            performance_mode                = "generalPurpose"
            throughput_mode                 = "bursting"
            provisioned_throughput_in_mibps = null
          }
        },
        "institucional" = {
          rds = {
            identifier                   = "educorp-institucional-prod"
            db_instance_class            = "db.t4g.medium"
            performance_insights_enabled = false
            skip_final_snapshot          = false
          }
          efs = {
            performance_mode                = "generalPurpose"
            throughput_mode                 = "bursting"
            provisioned_throughput_in_mibps = null
          }
        }
      }
    }
  }

  default_tags = {
    "conjunto-orcamentario" = "431082276051320606200323"
    "contato-gestor"        = "nome@educorp.app"
    "contato-tecnico"       = "nome@educorp.app"
    "cadeia-valor"          = "Educacao Corporativa"
    "sn-produto"            = "educorp"
    "sn-modulo"             = "educorp"
    "iac"                   = "Terraform"
    "repo"                  = "https://gitlab.com/platosedu/cosmos/devops/infra-platos"
  }
  
}