resource "aws_ecr_repository" "backend" {
  name         = coalesce(var.backend_repository_name, "spacelift-backend-${var.suffix}")
  force_delete = var.ecr_force_delete

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "backend" {
  count      = var.number_of_images_to_retain > 0 ? 1 : 0
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Only keep the ${var.number_of_images_to_retain} last images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.number_of_images_to_retain
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_repository" "launcher" {
  name         = coalesce(var.launcher_repository_name, "spacelift-launcher-${var.suffix}")
  force_delete = var.ecr_force_delete

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "launcher" {
  count      = var.number_of_images_to_retain > 0 ? 1 : 0
  repository = aws_ecr_repository.launcher.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Only keep the ${var.number_of_images_to_retain} last images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.number_of_images_to_retain
      }
      action = {
        type = "expire"
      }
    }]
  })
}
