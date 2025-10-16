resource "helm_release" "example" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.13.0"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = aws_eks_cluster.this.id
    },
    {
      name  = "serviceAccount.create"
      value = false
    },
    {
      name  = "region"
      value = var.auth.region
    },
        {
      name  = "vpcId"
      value = data.aws_vpc.this.id
    },
    {x
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
    }
  ]
}