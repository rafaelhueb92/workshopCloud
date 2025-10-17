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