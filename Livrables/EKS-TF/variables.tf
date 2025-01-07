variable "namespace" {
  description = "L'espace de noms de projet à utiliser pour la dénomination unique des ressources"
  default     = "fall-project"
  type        = string
}

variable "instance_type_bastion" {
  description = "Type d'instance pour le bastion"
  default     = "t2.micro"
  type        = string
}

variable "ami_type" {
  description = "Type d'image AMI AWS pour les serveurs eks"
  default     = "AL2_x86_64"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance pour les serveurs eks"
  default     = "t3a.medium"
  type        = string
}

variable "instance_number" {
  description = "Nombre d'instance pour les serveurs eks"
  default     = 2
  type        = number
}


variable "region" {
  description = "AWS région"
  default     = "eu-west-3"
  type        = string
}

variable "profile" {
  description = "environnement"
  default     = "dev"
  type        = string
}

variable "cluster_name" {
  description = "nom du cluster"
  default     = "fall-project-cluster"
  type        = string
}

variable "fall-project_repo" {
  description = "depot git du chart helm d'fall-project"
  default     = "git@github.com:CashNowMobile/fall-project-k8s.git"
  type        = string
}

variable "root_domain_name" {
  description = "nom de la racine du domaine"
  default = "olivierrey.cloudns.ph"
  type        = string
}

variable "GIT_SECRET_KEY" {
  type        = string
  description = "Secret key to access repo"
  sensitive   = true
}

variable "GRAFANA_PWD" {
  type        = string
  description = "grafana admin pass"
  sensitive   = true
}
