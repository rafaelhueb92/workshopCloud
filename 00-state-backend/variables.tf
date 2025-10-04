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

variable "remote_backend" { 
    type = object({
        bucket_name = string
        dynamo_table_name = string
        dynamo_table_billing_mode = string
        dynamo_table_hash_key = string
        dynamo_table_hash_key_attribute = string
    })
    default = {
        bucket_name = "workshop-remote-backend-bucket"
        dynamo_table_name = "workshop-state-lock"
        dynamo_table_billing_mode = "PAY_PER_REQUEST"
        dynamo_table_hash_key = "LockID"
        dynamo_table_hash_key_attribute = "S"
    }
}

