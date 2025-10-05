#!/bin/bash
set -euxo pipefail

# Update system (Amazon Linux 2)
yum update -y

# Install Git
yum install -y git

# Install Docker
yum install -y docker
systemctl enable --now docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install AWS CLI v2 if missing
if ! command -v aws >/dev/null 2>&1; then
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  yum install -y unzip
  unzip -q /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

# Install jq (useful for metadata parsing)
yum install -y jq

# Create ECR login helper
cat >/home/ec2-user/ecr-login.sh <<'SCRIPT'
#!/bin/bash
set -euo pipefail
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region || echo "${AWS_REGION:-us-east-1}")
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
echo "Logged in to ECR: $ACCOUNT_ID in $REGION"
SCRIPT
chmod +x /home/ec2-user/ecr-login.sh
chown ec2-user:ec2-user /home/ec2-user/ecr-login.sh