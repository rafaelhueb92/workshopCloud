output "eks_cluster_id" {
    value = aws_eks_cluster.this.id
}

output "private_subnets_id" {
    value = data.aws_subnets.private.ids
}