



## Build CodeBuild projects for Terraform Plan and Terraform Apply
module "codebuild" {
  source                                 = "./codebuild"
  environment                            = var.environment
  codebuild_project_terraform_plan_name  = var.codebuild_project_terraform_plan_name
  codebuild_project_terraform_apply_name = var.codebuild_project_terraform_apply_name
  s3_logging_bucket_name                 = var.s3_logging_bucket_name
  codebuild_iam_role_name                = var.codebuild_iam_role_name
  codebuild_iam_role_policy_name         = var.codebuild_iam_role_policy_name
}

## Build a CodePipeline
module "codepipeline" {
  source                               = "./codepipeline"
  environment                          = var.environment
  tf_codepipeline_name                 = var.tf_codepipeline_name
  tf_codepipeline_artifact_bucket_name = var.tf_codepipeline_artifact_bucket_name
  tf_codepipeline_role_name            = var.tf_codepipeline_role_name
  tf_codepipeline_role_policy_name     = var.tf_codepipeline_role_policy_name
  codebuild_terraform_plan_name        = module.codebuild.codebuild_terraform_plan_name
  codebuild_terraform_apply_name       = module.codebuild.codebuild_terraform_apply_name
  pipeline_name                        = var.pipeline_name
  infrastructure_repo_name             = var.infrastructure_repo_name
  aws_account_id                       = var.aws_account_id
  connection_id                        = var.connection_id
  tags                                 = var.tags
  git_branch                           = var.git_branch
}
