resource "aws_iam_role" "github" {
  name = "DvnWorkshopGithubRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc_provider.arn
        }
        Condition = {
          StringLike = {
                 "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                 "token.actions.githubusercontent.com:sub": "repo:rafaelhueb92/workshopCloud:ref:refs/heads/*"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "github" {
  name        = "DvnWorkshopGithubRole"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Action": [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
        "ecr:GetAuthorizationToken"
      ],
      "Resource": aws_ecr_repository.this[*].arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "github" {
  policy_arn = aws_iam_policy.github.arn
  role       = aws_iam_role.github.name
}