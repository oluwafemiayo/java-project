variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "main-vpc"
}


variable "cidr_block" {
  type    = string
  default = "10.5.0.0/16"
}


variable "author" {
  type    = string
  default = "Steph"
}



variable "min_node_count" {
  type    = number
  default = 2
}



variable "max_node_count" {
  type    = number
  default = 8
}



variable "machine_type" {
  type    = string
  default = "t2.small"
}


variable "aws_availability_zones" {
  type    = any
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
}