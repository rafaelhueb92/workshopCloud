resource "aws_ecr_repository" "this" {
  count = length(var.aws_ecr_repositories)
  name                 = var.aws_ecr_repositories[count.index].name
  image_tag_mutability = "MUTABLE"
}