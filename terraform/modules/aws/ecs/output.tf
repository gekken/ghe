output "region" {
  value = "${var.region}"
}

output "ecs_gheVPC" {
  value = "${aws_vpc.ecs_gheVPC.id}"
}
