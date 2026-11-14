output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}
output "repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}
output "repository_name" {
  description = "ECR repository name"
  value       = module.ecr.repository_name
}
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}
output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}
output "eks_node_group_name" {
  description = "EKS managed node group name"
  value       = module.eks.node_group_name
}
