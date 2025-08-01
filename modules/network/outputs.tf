output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.spacelift_vpc.id
}

output "private_subnet_ids" {
  description = "A map of availability zones to private subnet IDs"
  value = zipmap(
    aws_subnet.private_subnets[*].availability_zone,
    aws_subnet.private_subnets[*].id,
  )
}

output "public_subnet_ids" {
  description = "A map of availability zones to public subnet IDs"
  value = zipmap(
    aws_subnet.public_subnets[*].availability_zone,
    aws_subnet.public_subnets[*].id,
  )
}

output "database_security_group_id" {
  description = "The ID of the security group for the Spacelift database. Will be null if create_database is false."
  value       = var.create_database ? aws_security_group.database_sg[0].id : null
}

output "server_security_group_id" {
  description = "The ID of the security group for the Spacelift HTTP server"
  value       = aws_security_group.server_sg.id
}

output "drain_security_group_id" {
  description = "The ID of the security group for the Spacelift async-processing service"
  value       = aws_security_group.drain_sg.id
}

output "vcs_gateway_security_group_id" {
  description = "The ID of the security group for the Spacelift VCS gateway service. Will be null if create_vcs_gateway is false."
  value       = var.create_vcs_gateway ? aws_security_group.vcs_gateway_sg[0].id : null
}

output "scheduler_security_group_id" {
  description = "The ID of the security group for the Spacelift cron scheduler service"
  value       = aws_security_group.scheduler_sg.id
}
