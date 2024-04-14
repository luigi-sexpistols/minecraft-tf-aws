terraform {
  required_version = ">= 1.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5, < 6"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

provider "aws" {
  region = var.aws.region

  default_tags {
    tags = {
      Name = var.project_name
      Project = var.project_name
    }
  }
}
