# Terraform Workspaces (workspace selection based on the GitHub input)
terraform {
  required_version = ">= 0.12"
}

# Dynamically select the workspace
resource "null_resource" "workspace_selector" {
  provisioner "local-exec" {
    command = "terraform workspace select ${terraform.workspace} || terraform workspace new ${terraform.workspace}"
  }
}