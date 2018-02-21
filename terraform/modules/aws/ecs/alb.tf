resource "aws_alb" "ecs-gheELB" {
    name                = "ecs-load-balancer"
    security_groups     = ["${aws_security_group.ecs_ghePubSG.id}"]
    subnets             = ["${aws_subnet.ecs_ghePSN01.id}", "${aws_subnet.ecs_ghePSN02.id}"]

    tags {
      Name = "ecs-load-balancer"
    }
}

resource "aws_alb_target_group" "ecs-gheTargetGroup" {
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.ecs_gheVPC.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags {
      Name = "ecs-target-group"
    }
}

resource "aws_alb_listener" "ecs_gheALB-Listener" {
    load_balancer_arn = "${aws_alb.ecs-gheELB.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.ecs-gheTargetGroup.arn}"
        type             = "forward"
    }
}
