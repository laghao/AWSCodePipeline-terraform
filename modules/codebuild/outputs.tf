# Output TF Plan CodeBuild name to main.tf
output "codebuild_terraform_plan_name" {
  value = aws_codebuild_project.codebuild_project_terraform_plan.name
}

# Output TF Plan CodeBuild name to main.tf
output "codebuild_terraform_apply_name" {
  value = aws_codebuild_project.codebuild_project_terraform_apply.name
}

output "codebuild_iam_role_arn" {
  value = aws_iam_role.codebuild_iam_role.arn
}