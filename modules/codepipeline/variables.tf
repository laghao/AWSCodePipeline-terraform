variable "tf_codepipeline_artifact_bucket_name" {
  description = "Name of the TF CodePipeline S3 bucket for artifacts"
}
variable "tf_codepipeline_role_name" {
  description = "Name of the Terraform CodePipeline IAM Role"
}
variable "tf_codepipeline_role_policy_name" {
  description = "Name of the Terraform IAM Role Policy"
}
variable "tf_codepipeline_name" {
  description = "Terraform CodePipeline Name"
}
variable "codebuild_terraform_plan_name" {
  description = "Terraform plan codebuild project name"
}
variable "codebuild_terraform_apply_name" {
  description = "Terraform apply codebuild project name"
}
variable "managedsvc_project_name" {
  default = "Managed Services Bitbucket Project name"  
}
variable "infrastructure_repo_name" {
  default = "Managed Services infrastructure Bitbucket repository name" 
}
variable "aws_account_id" {
  default = "AWS Account ID"  
}
variable "connection_id" {
  default = "Codestar bitbucket connection id"
}
variable "region" {}
variable "git_branch" {
  default = "Bitbucket project branch"
}

