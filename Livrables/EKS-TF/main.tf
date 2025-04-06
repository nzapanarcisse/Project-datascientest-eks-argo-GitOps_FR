data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
  #  depends_on = [ module.eks.eks_managed_node_groups, ]
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host  = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster_auth.default.id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host  = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster_auth.default.id]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false
  apply_retry_count      = 3

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster_auth.default.id]
  }
}

resource "aws_s3_bucket" "tfstate" {
  bucket        = "terraform-cluster-demo02" # Remplacez par un nom unique
  acl           = "private"

  tags = {
    Name        = "example-s3-bucket"
    Environment = "Dev"
  }
}

terraform {
  backend "s3" {
    bucket                  = "terraform-cluster-demo02"
    key                     = "Lepro-dev.tfstate"
    region                  = "us-east-1"
  }
 /* cloud {
  }*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

resource "kubernetes_namespace" "fall-project" {
  metadata {
    name = "fall-project"
  }
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "eks" {
  source              = "./modules/eks"
  namespace           = var.namespace
  ami_type            = var.ami_type
  instance_type       = var.instance_type
  instance_number     = var.instance_number
  vpc                 = module.networking.vpc
  private_subnets     = module.networking.vpc.private_subnets
  sg_private_id       = module.networking.sg_priv_id
  region              = var.region
  cluster_name        = var.cluster_name
  profile             = var.profile
  eks_admins_iam_role = module.eks.eks_admins_iam_role
}

#module "argocd" {
#  source                = "./modules/argocd"
#  fall-project_repo            = var.fall-project_repo
#  fall-project_repo_secret_key = var.GIT_SECRET_KEY
#  profile = var.profile
#}

#module "prometheus" {
#  source      = "./modules/prometheus"
#  grafana_pwd = var.GRAFANA_PWD
#  profile = var.profile
#  namespace           = var.namespace
#  root_domain_name = var.root_domain_name
#}

#module "velero" {
#  source       = "./modules/velero"
#  cluster_name = var.cluster_name
#  region = var.region
#  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
#}

#module "cert_manager" {
#  source       = "./modules/cert_manager"
#  profile = var.profile
#}

#module "ingress" {
#  source      = "./modules/ingress"
#  profile = var.profile
#  namespace           = var.namespace
#  root_domain_name = var.root_domain_name
#}



#module "bastion" {
#  source        = "./modules/bastion"
#  namespace     = var.namespace
#  instance_type = var.instance_type_bastion
#  vpc           = module.networking.vpc
#  sg_pub_id     = module.networking.sg_pub_id
#  key_name      = "fall-project"
#}
