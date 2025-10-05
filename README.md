# 🚀 DevOps Project in the Cloud

A hands-on DevOps workshop demonstrating cloud infrastructure and GitOps practices.

## 🚧 Status

Under construction. Documentation and implementation details will be added as the project progresses.

## 🛠️ Tech Stack

- ☁️ **AWS** — Cloud Provider
- 🏗️ **Terraform** — Infrastructure as Code
- ⎈ **EKS** — Kubernetes on AWS
- 🔁 **ArgoCD** — GitOps Continuous Delivery

## ⭐ Stay Updated

Star this repo to follow the progress!

## 📚 Helpful Link

- Install the AWS Load Balancer Controller: https://docs.aws.amazon.com/pt_br/eks/latest/userguide/lbc-helm.html

## 🧰 Using EC2 to Push Images (for local macOS workflows)

1. Navigate to:

   infra/04-ec2-to-push-image-if-local-macos

2. Initialize and provision with Terraform:

   terraform init

   terraform plan

   terraform apply -auto-approve

3. Verify current user:

   Connect into the ec2 with Session Manager and execute:

   whoami

4. Add the user to the docker group (replace `USER` with `ssm-user` or `ec2-user`):

   sudo usermod -aG docker USER

5. Enable and start Docker (if not running):

   sudo systemctl enable --now docker

6. Refresh your shell so new group membership applies:

   - Option A: Log out and back in (for SSM, terminate and start a new session)
   - Option B: Start a fresh login shell:

     - For `ec2-user`:

       sudo -iu ec2-user

     - For `ssm-user`:

       sudo -iu ssm-user
