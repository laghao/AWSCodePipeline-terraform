variable "region" {
  type = map(string)

  default = {
    test   = "eu-central-1"
    master = "eu-central-1"
  }
}

variable "environment" {
  type = map(string)

  default = {
    test   = "test"
    master = "production"
  }
}

variable "git_branch" {
  type = map(string)

  default = {
    test   = "develop"
    master = "master"
  }
}

variable "project_name" {
  type = map(string)

  default = {
    test   = "my-project_test"
    master = "my-project_prod"
  }
}