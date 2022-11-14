
# data "aws_availability_zones" "azs" {
#   state = "available"
# }


locals {
  az_names           = var.aws_availability_zones
  public_subnets_ids = aws_subnet.publicsubnet.*.id
}


############################################
######## Create VPC #######################

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name"                                              = "${var.cluster_name}-vpc"
    "Author"                                            = var.author
    "kubernetes.io/cluster/${var.cluster_name}-cluster" = "shared"
  }
}



###########################################
#### Public Subnet ########################

resource "aws_subnet" "publicsubnet" {
  count             = length(local.az_names)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone = local.az_names[count.index]

  map_public_ip_on_launch = true

  tags = {
    Name                                                = "PublicSubnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.cluster_name}-cluster" = "shared"
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}



resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_name}-rt"
  }
}



resource "aws_route_table_association" "public" {
  count          = length(local.az_names)
  subnet_id      = local.public_subnets_ids[count.index]
  route_table_id = aws_route_table.public_route_table.id
}