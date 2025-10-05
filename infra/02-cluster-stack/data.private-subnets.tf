data "aws_subnets" "private" {
  filter {
    name   = "tag:Project"
    values = ["workshop-devops-na-nuvem"]
  }
   filter {
    name   = "tag:Environment"
    values = ["Production"]
  }
   filter {
    name   = "map-public-ip-on-launch"
    values = [false]
  }
}