resource "aws_ecs_task_definition" "ecs_gheTD" {
  family                = "service"
  container_definitions = "${file("service.json")}"

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
