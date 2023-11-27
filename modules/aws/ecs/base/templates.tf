data "template_file" "ecs_role" {
  template = file("${path.module}/templates/ecs_assume_role.json")
}
