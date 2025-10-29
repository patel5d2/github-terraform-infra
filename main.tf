terraform {
  required_version = ">= 1.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Uncomment for remote state storage
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "github-infra/terraform.tfstate"
  #   region = "us-east-1"
  # }

  # Or use Terraform Cloud
  # cloud {
  #   organization = "my-org"
  #   workspaces {
  #     name = "github-infrastructure"
  #   }
  # }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}
