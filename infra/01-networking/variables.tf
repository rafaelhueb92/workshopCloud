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

variable "vpc" {
    type = object({
        name = string
        cidr = string
        internet_gateway_name = string
        nat_gateway_name      = string
        public_subnets = list(object({
            name = string
            cidr_block = string
            availability_zone = string
            map_public_ip_on_launch = bool
        }))
         private_subnets = list(object({
            name = string
            cidr_block = string
            availability_zone = string
            map_public_ip_on_launch = bool
        }))
        public_route_table_name = string
        private_route_table_name = string
    })
    default = { 
        name = "devops-na-nuvem-workshop"
        nat_gateway_name = "dvn-workshop-nat-gateway"
        cidr = "10.0.0.0/24"
        internet_gateway_name = "dvn-workshop-vpc-igw"
        public_subnets = [{
            name = "dvn-workshop-vpc-public-subnet-us-east-1a",
            cidr_block = "10.0.0.0/26"
            availability_zone = "us-east-1a"
            map_public_ip_on_launch = true
        },{
            name = "dvn-workshop-vpc-public-subnet-us-east-1b",
            cidr_block = "10.0.0.64/26"
            availability_zone = "us-east-1b"
            map_public_ip_on_launch = true
        }]
         private_subnets = [{
            name = "dvn-workshop-vpc-private-subnet-us-east-1a",
            cidr_block = "10.0.0.128/26"
            availability_zone = "us-east-1a"
            map_public_ip_on_launch = false
        },{
            name = "dvn-workshop-vpc-private-subnet-us-east-1b",
            cidr_block = "10.0.0.192/26"
            availability_zone = "us-east-1b"
            map_public_ip_on_launch = false
        }]
        public_route_table_name = "dvn-workshop-vpc-public-route-table"
        private_route_table_name = "dvn-workshop-vpc-private-route-table"
    }
}