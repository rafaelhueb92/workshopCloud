resource "helm_release" "load_balacner_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.13.0"
  namespace  = "kube-system"

  set {
      name  = "clusterName"
      value = aws_eks_cluster.this.id
  }

  set {
      name  = "serviceAccount.create"
      value = true
  }

  set {
      name  = "region"
      value = var.auth.region
  }
  
  set {
      name  = "vpcId"
      value = data.aws_vpc.this.id
  }

  set{
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
  }

  set {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.load_balancer_controller_role.arn
  }
  
}