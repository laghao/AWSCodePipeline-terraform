variable "codebuild_project_terraform_plan_name" {
  description = "Name for CodeBuild Terraform Plan Project"
}
variable "codebuild_project_terraform_apply_name" {
  description = "Name for CodeBuild Terraform Apply Project"
}
variable "s3_logging_bucket_name" {
  description = "Name of S3 bucket to use for access logging"
}
variable "codebuild_iam_role_name" {
  description = "Name for IAM Role utilized by CodeBuild"
}
variable "codebuild_iam_role_policy_name" {
  description = "Name for IAM policy used by CodeBuild"
}
