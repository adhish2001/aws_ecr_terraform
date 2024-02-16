terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
    
}
provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "ecr_repo" {
    #checkov:skip=CKV_AWS_51: "Ensure ECR Image Tags are immutable"
    #checkov:skip=CKV_AWS_163: "Ensure ECR image scanning on push is enabled"
  name = var.ecr_repo_name
  force_delete = true
  
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "flask-resume-repo-lifecycle-policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description = "Expire images older than 14 days",
        selection = {
          tagStatus = "untagged",
          countType = "sinceImagePushed",
          countUnit = "days",
          countNumber = 14
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}