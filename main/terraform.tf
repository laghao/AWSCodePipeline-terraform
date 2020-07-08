terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-environment-locking-table"
    region         = "eu-central-1"
    encrypt        = true
  }
}

