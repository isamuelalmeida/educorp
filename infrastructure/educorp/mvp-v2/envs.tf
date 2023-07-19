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
      stage = {
        "eco" = {
          rds = {
            identifier                   = "educorp-eco-stage"
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
        "sandbox" = {
          rds = {
            identifier                   = "educorp-sandbox-stage"
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
        "callink" = {
          rds = {
            identifier                   = "educorp-callink-stage"
            db_instance_class            = "db.t4g.medium"
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
            identifier                   = "educorp-callink-production"
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
            identifier                   = "educorp-cogna-production"
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
            identifier                   = "educorp-institucional-production"
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

  envs = {
    default = {
      region = "us-east-1"
    }

    dev = {
      environment                    = "dev"
      region                         = "us-east-1"
      vpc_id                         = "vpc-0120ce9620079d30f"
      vpc_database_subnet_group_name = "platos-dev"
      vpc_database_subnets = [
        "subnet-070bd06dc552c28a3",
        "subnet-0de60c5e5bccb1756",
        "subnet-046b10f1f9a5729cf"
      ]
      rds_security_group_ids = [
        "sg-00444ff26f09ca215",
        "sg-0c039f8d333b03164",
        "sg-0ed1fc683f374ed25"
      ]
    }

    stage = {
      environment                    = "stage"
      region                         = "us-east-1"
      vpc_id                         = "vpc-03952ffeeba8241d5"
      vpc_database_subnet_group_name = "platos-stage"
      vpc_database_subnets = [
        "subnet-08597c9e498055171",
        "subnet-0493e92e985fb2d1d",
        "subnet-081ae0d3a732b6be5"
      ]
      rds_security_group_ids = [
        "sg-0719ff9486d4e9584",
        "sg-0b0ab1324f6804f03",
        "sg-0b11d848ed28afc6a"
      ]
    }

    production = {
      environment                    = "production"
      region                         = "us-east-1"
      vpc_id                         = "vpc-06f3035be49b3f7c5"
      vpc_database_subnet_group_name = "cosmos.production"
      vpc_database_subnets = [
        "subnet-030c776cb16b46bf3",
        "subnet-0a4ad4a50e9c375e7"
      ]
      rds_security_group_ids = [
        "sg-00071a89cf976bb83",
        "sg-00b83ecae789fde39"
      ]
    }

    default_tags = {
      "conjunto-orcamentario" = "431082276051320606200323"
      "contato-gestor"        = "nelson.sjunior@platosedu.com.br"
      "contato-tecnico"       = "leonardo.bedendo@platosedu.com.br"
      "cadeia-valor"          = "Educacao Corporativa"
      "sn-produto"            = "educorp"
      "sn-modulo"             = "platos"
      "iac"                   = "Terraform"
      "repo"                  = "https://gitlab.com/platosedu/cosmos/devops/infra-platos"
    }
    default_tag_estagio_by_env = {
      "default"    = "HML"
      "dev"        = "DEV"
      "stage"      = "HML"
      "production" = "PRD"
    }
    aws_role_arn = "arn:aws:iam::703669458031:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Operator_Access_8966e92af2ed681d"
  }
}