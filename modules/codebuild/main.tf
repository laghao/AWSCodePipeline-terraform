# Build an AWS S3 bucket for logging
resource "aws_s3_bucket" "s3_logging_bucket" {
  bucket = "${var.s3_logging_bucket_name}-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
# Create an IAM role for CodeBuild to assume
resource "aws_iam_role" "codebuild_iam_role" {
  name = "${var.codebuild_iam_role_name}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# Create an IAM role policy for CodeBuild to use implicitly
resource "aws_iam_role_policy" "codebuild_iam_role_policy" {
  name = "${var.codebuild_iam_role_policy_name}-${var.environment}"
  role = aws_iam_role.codebuild_iam_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
POLICY
}


# Create CodeBuild Project for Terraform Plan
# TODO use hashicorp/terraform image instead
resource "aws_codebuild_project" "codebuild_project_terraform_plan" {
  name          = "${var.codebuild_project_terraform_plan_name}-${var.environment}"
  description   = "Terraform codebuild project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_iam_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.s3_logging_bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable = [
    {
      name  = "TERRAFORM_VERSION"
      value = "0.12.20"
    },
    {
      name  = "TF_WORKSPACE"
      value = "${var.environment}"
    },
  ]
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.s3_logging_bucket.id}/${aws_s3_bucket.s3_logging_bucket.codebuild_project_terraform_plan.name}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./templates/buildspec_terraform_plan.yml"
  }

  tags = {
    Terraform = "true"
  }
}


# Create CodeBuild Project for Terraform Apply
# TODO use hashicorp/terraform image instead
resource "aws_codebuild_project" "codebuild_project_terraform_apply" {
  name          = "${var.codebuild_project_terraform_apply_name}-${var.environment}"
  description   = "Terraform codebuild project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_iam_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_buckt.s3_logging_bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

     environment_variable = [
    {
      name  = "TERRAFORM_VERSION"
      value = "0.12.20"
    },
    {
      name  = "TF_WORKSPACE"
      value = "${var.environment}"
    },
  ]
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.s3_logging_bucket.id}/${aws_s3_bucket.s3_logging_bucket.codebuild_project_terraform_plan.name}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./templates/buildspec_terraform_apply.yml"
  }

  tags = {
    Terraform = "true"
  }
}