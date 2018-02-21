variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "Availability zone used"
  default = {
    us-west-2 = "us-west-2a"
    us-east-2 = "us-east-2a"
  }
}

variable "ecs_gheVPC" {
  description = "VPC for GHE Demonstration"
}

variable "ecs_ghe_network_cidr" {
  description = "IP range in CIDR for ecs_gheVPC"
}

variable "ecs_ghe_public_cidr01" {
  description = "Public CIDR for Public SN 1"
  default = "10.0.0.0/16"
}

variable "ecs_ghe_public_cidr02" {
  description = "Public CIDR for Public SN 2"
  default = "10.0.1.0/16"
}

########################################
##                 Notes              ##
########################################
## For some stupid reason, I'm not    ##
## to interpolate the CIDR notation   ##
## passing on this for now.           ##
########################################
