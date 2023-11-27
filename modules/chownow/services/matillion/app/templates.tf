data "template_file" "ec2_role" {
  template = file("${path.module}/templates/ec2_role.json.tpl")
}
