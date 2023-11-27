data "template_file" "backup_role" {
  template = file("${path.module}/templates/backup_role.json.tpl")
}

data "template_file" "backup_policy" {
  template = file("${path.module}/templates/backup_policy.json.tpl")
}
