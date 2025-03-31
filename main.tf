# Terraform Workspaces (workspace selection based on the GitHub input)
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Or specify another version if needed
    }
    null = {
      source = "hashicorp/null"
      version = "~> 5.0"  # Version for the null provider
    }
  }
}

# Dynamically select the workspace
resource "null_resource" "workspace_selector" {
  provisioner "local-exec" {
    command = "terraform workspace select ${terraform.workspace} || terraform workspace new ${terraform.workspace}"
  }
}