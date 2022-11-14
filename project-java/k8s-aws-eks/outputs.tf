output "region" {
  value = var.region
}


output "cluster_name" {
  value = aws_eks_cluster.staging.name
}