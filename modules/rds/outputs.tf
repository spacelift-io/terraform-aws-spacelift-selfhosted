output "cluster_identifier" {
  description = "Name of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.cluster_identifier
}

output "cluster_resource_id" {
  description = "Cluster resource ID of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.cluster_resource_id
}

output "cluster_arn" {
  description = "ARN of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.arn
}

output "cluster_endpoint" {
  description = "Endpoint of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.endpoint
}

output "reader_endpoint" {
  description = "Reader endpoint of the RDS cluster."
  value       = aws_rds_cluster.db_cluster.reader_endpoint
}

output "db_password" {
  description = "Password for the RDS database."
  value       = local.password
  sensitive   = true
}

output "database_name" {
  description = "Name of the database."
  value       = local.database_name
}

output "secrets_manager_database_connection_string_name" {
  description = "Name of the Secrets Manager secret for the database connection string."
  value       = aws_secretsmanager_secret.conn_string.name

}

output "secrets_manager_database_connection_string_arn" {
  description = "Connection string for the database stored in Secrets Manager."
  value       = aws_secretsmanager_secret.conn_string.arn
}

output "secrets_manager_database_connection_string_version_id" {
  description = "Version ID of the Secrets Manager secret for the database connection string."
  value       = aws_secretsmanager_secret_version.conn_string.version_id
}
