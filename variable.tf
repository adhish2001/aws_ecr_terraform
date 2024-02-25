variable "ecr_repo_name" {
    type        = string
    description = "The name variable used for the ecr repository"
    default = "default-ecr-repo"
}
variable "aws_region" {
    type        = string
    description = "The AWS region"
    default     = "us-east-2"
}