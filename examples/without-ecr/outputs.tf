# Re-exported for the after_apply checks in .spacelift/config.yml.
output "ecr_backend_repository_url" {
  value = module.spacelift.ecr_backend_repository_url
}

output "shell" {
  value = module.spacelift.shell
}
