# Provider configuration
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2-ecr-push-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM core managed policy to the role (enables Session Manager)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Policy for ECR push
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
          "ecr:CompleteLayerUpload"
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

# Security Group - no inbound needed for SSM; keep 22 open only if you want SSH
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-ecr-sg"
  description = "Security group for EC2 instance (SSM access; no inbound needed)"

  # Optional SSH - comment out to disable SSH entirely
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]  # Restrict this to your IP if you keep SSH
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ecr_builder" {
  ami                    = "ami-052064a798f08f0d3"  # Amazon Linux 2 (verify for your region)
  instance_type          = "t3.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_ecr_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # If you are in a default VPC public subnet, a public IP or NAT is fine for SSM.
  # For private-only subnets without NAT, add SSM VPC endpoints instead.

  user_data = file("${path.module}/user_data.sh") 

  tags = {
    Name = "ECR-Builder-Instance"
  }
}

# Output
output "instance_id" {
  value = aws_instance.ecr_builder.id
}

output "ssm_connect_command" {
  value = "aws ssm start-session --target ${aws_instance.ecr_builder.id}"
}