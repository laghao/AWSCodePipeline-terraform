# Build S3 bucket for CodePipeline artifact storage
resource "aws_s3_bucket" "tf_codepipeline_artifact_bucket" {
  bucket = "${var.tf_codepipeline_artifact_bucket_name}-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_iam_role" "tf_codepipeline_role" {
  name = "${var.tf_codepipeline_role_name}-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tf_codepipeline_policy" {
  name = "${var.tf_codepipeline_role_policy_name}-${var.environment}"
  role = aws_iam_role.tf_codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
EOF
}


#TODO add codestart connection manually from aws GUI and add connection_id variable

resource "aws_codepipeline" "tf_codepipeline" {
  name     = "${var.tf_codepipeline_name}-${var.environment}"
  role_arn = aws_iam_role.tf_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.tf_codepipeline_artifact_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        ConnectionArn        = "arn:aws:codestar-connections:${var.region}:${var.aws_account_id}:connection/${var.connection_id}"
        FullRepositoryId     = "${var.pipeline_name}/${var.infrastructure_repo_name}"
        BranchName           = var.git_branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Terraform_Plan"

    action {
      name             = "Terraform-Plan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_terraform_plan_name
      }
    }
  }

stage {
  name = "Manual_Approval"

  action {
    name     = "Manual-Approval"
    category = "Approval"
    owner    = "AWS"
    provider = "Manual"
    version  = "1"
  }
}

  stage {
    name = "Terraform_Apply"

    action {
      name            = "Terraform-Apply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        ProjectName = var.codebuild_terraform_apply_name
      }
    }
  }
}
