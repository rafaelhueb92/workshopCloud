variable "auth" {
    type = object({
        region = string
        assume_role_arn = string
    })

    default = {
        assume_role_arn = "arn:aws:iam::180294221572:role/WorkshopNaNuvemRole"
        region = "us-east-1"
    }
}

variable "tags" { 
    type = map(string)
    default = {
        Project = "workshop-devops-na-nuvem"
        Environment = "Production"
    }
}

variable "eks_cluster" {
  type = object({
    name                              = string
    version                           = string
    enabled_cluster_log_types         = list(string)
    access_config_authentication_mode = string
    node_group_name                   = string
    node_group_instance_types         = list(string)
    node_group_capacity_type          = string
    scaling_config_desired_size       = number
    scaling_config_max_size           = number
    scaling_config_min_size           = number
  })

  default = {
    name                              = "dvn-workshop-eks-cluster"
    version                           = "1.31"
    enabled_cluster_log_types         = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    access_config_authentication_mode = "API_AND_CONFIG_MAP"
    node_group_name                   = "dvn-workshop-eks-cluster-node-group"
    node_group_instance_types         = ["t3.medium"]
    node_group_capacity_type          = "ON_DEMAND"
    scaling_config_desired_size       = 2
    scaling_config_max_size           = 2
    scaling_config_min_size           = 2
  }
}

variable "aws_ecr_repositories" {
    type = list(object({
        name = string
}))
    default = [{
        name = "dvn-workshop/production/backend"
    },{
        name = "dvn-workshop/production/frontend"
    }]
}

variable "create_oidc_github" { 
    type = bool
    default = false
}