resource "aws_launch_configuration" "ecs-gheLC" {
    name                        = "ecs-gheLC"
    image_id                    = "ami-10ed6968"
    instance_type               = "t2.small"
    iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = ["${aws_security_group.ecs_ghePubSG.id}"]
    associate_public_ip_address = "true"
    key_name                    = "${var.ecs_key_pair_name}"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_gheCluster} >> /etc/ecs/ecs.config
                                  EOF
}
