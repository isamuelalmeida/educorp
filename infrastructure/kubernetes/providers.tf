terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "infra-cognalabs-terraform-state"
    key    = "infra-cognalabs-kubernetes.tfstate"
    region = "us-east-1"
    profile = "educorp_prod"
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