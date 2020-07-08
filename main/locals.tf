locals {
  tags = {
    Environment = var.environment[terraform.workspace]
    TF-Managed  = "true"
  }
}

