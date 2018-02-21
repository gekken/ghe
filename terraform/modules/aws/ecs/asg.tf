resource "aws_autoscaling_group" "ecs-gheASG" {
    name                        = "ecs-gheASG"
    max_size                    = "${var.max_instance_size}"
    min_size                    = "${var.min_instance_size}"
    desired_capacity            = "${var.desired_capacity}"
    vpc_zone_identifier         = ["${aws_subnet.ecs_ghePSN01.id}", "${aws_subnet.ecs_ghePSN02.id}"]
    launch_configuration        = "${aws_launch_configuration.ecs-gheLC.name}"
    health_check_type           = "ELB"
  }
