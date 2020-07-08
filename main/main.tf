

module "pipeline" {
  source        = "../modules/pipeline"
  environment   = var.environment
  region        = var.region[terraform.workspace]
  project_name  = var.project_name[terraform.workspace]
  tags          = local.tags
  git_branch    = var.git_branch[terraform,workspace] 
}

