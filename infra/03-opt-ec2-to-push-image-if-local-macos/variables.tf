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
