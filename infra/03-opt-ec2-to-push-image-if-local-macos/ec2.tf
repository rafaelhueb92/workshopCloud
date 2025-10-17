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