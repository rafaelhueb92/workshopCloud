data "aws_vpc" "this" {
   filter {
    name   = "tag:Name"
    values = ["devops-na-nuvem-workshop"]
  }
}