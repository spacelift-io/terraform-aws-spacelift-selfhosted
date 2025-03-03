output "ecr_backend_repository_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "ecr_launcher_repository_url" {
  value = aws_ecr_repository.launcher.repository_url
}
