data "template_file" "resource_group_filter" {
  template = file("${path.module}/templates/resource_group_filter.tpl")

  vars = {
    environment = var.environment[terraform.workspace]
  }
}

