output "database_global_aurora_identifier" {
  description = "ID of the global Aurora cluster."
  value       = aws_rds_global_cluster.global_cluster.id
}

output "cluster_resource_id" {
  description = "Cluster resource ID of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.cluster_resource_id
}

output "db_password" {
  description = "Password for the RDS database."
  value       = random_password.db_pw.result
  sensitive   = true
}
