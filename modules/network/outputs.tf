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

output "database_security_group_id" {
  description = "The ID of the security group for the Spacelift database"
  value       = aws_security_group.database_sg.id
}

output "server_security_group_id" {
  description = "The ID of the security group for the Spacelift HTTP server"
  value       = aws_security_group.server_sg.id
}

output "drain_security_group_id" {
  description = "The ID of the security group for the Spacelift async-processing service"
  value       = aws_security_group.drain_sg.id
}
