terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-platos-terraform-state"
    key    = "infra-platos-kubernetes.tfstate"
    region = "us-east-1"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.9.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.7.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region = module.env_info.envs[terraform.workspace].region

  assume_role {
    role_arn = module.env_info.envs[terraform.workspace].aws_provider_role_arn
  }

  default_tags {
    tags = merge(
      module.env_info.envs.default_tags,
      { "estagio" = module.env_info.envs.default_tag_estagio_by_env[terraform.workspace] }
    )
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  ignore_annotations = [
    "field.cattle.io/publicEndpoints"
  ]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "keycloak" {
  # Obs: Ver arquivo modules/keycloak/README.md com as instrução para configurar o client do terraform no Keycloak
  client_id     = data.aws_ssm_parameter.keycloak_terraform_client_id.value
  client_secret = data.aws_ssm_parameter.keycloak_terraform_client_secret.value
  url           = "https://sso.${module.env_info.envs[terraform.workspace].domain}"
  # base_path deve ficar vazio após a migração do WildFly para o Quarkus
  # https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs#base_path
  # base_path = contains(["dev"], terraform.workspace) ? "/auth" : ""
}

provider "vault" {
  address = "https://vault.${module.env_info.envs[terraform.workspace].domain}"
  token   = lookup(local.vault_cluster_keys, "root_token")
}