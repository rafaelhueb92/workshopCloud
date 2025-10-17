AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

kubectl create clusterrolebinding workshop-out-user-admin \
  --clusterrole=cluster-admin \
  --user=arn:aws:iam::$AWS_ACCOUNT_ID:user/workshop-out-user