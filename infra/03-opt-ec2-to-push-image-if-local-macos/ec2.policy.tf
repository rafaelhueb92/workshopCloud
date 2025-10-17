resource "aws_iam_role_policy" "ecr_push_policy" {
  name = "ecr-push-policy"
  role = aws_iam_role.ec2_ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:CreateRepository",
          "ecr:DescribeRepositories"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "ec2-ecr-push-profile"
  role = aws_iam_role.ec2_ecr_role.name
}