data "template_file" "ec2_role" {
  template = file("${path.module}/templates/ec2_role.json.tpl")
}
data "template_file" "user_data" {
  template = file("${path.module}/templates/ec2_user_data.tpl")
}
