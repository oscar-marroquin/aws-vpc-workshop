##################################################################################
# VARIABLES
##################################################################################

variable "region"  {}
variable "company_name" {}
variable "business_unit" {}
variable "environment_tag" {}


##################################################################################
# DATA  
##################################################################################

data "aws_availability_zones" "available" {}



##################################################################################
# RESOURCES - VPC and Gateways
##################################################################################

resource "aws_vpc" "main" {
  cidr_block            = var.network_address_space[terraform.workspace]
  instance_tenancy      = "default"
  enable_dns_hostnames  = "true"

  tags = {
      Name = "${local.co_name}-${local.biz_name}-${local.env_name}-vpc-1"
      Description = "Managed by Terraform"
  }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name        = "${local.co_name}-${local.biz_name}-${local.env_name}-igw"
        Description = "Managed by Terraform"
    }
  
}

resource "aws_eip" "main" {
    count       = var.subnet_count[terraform.workspace]
    vpc         = true
    depends_on  = [aws_internet_gateway.main]

    tags = {
        Name        = "${local.co_name}-${local.biz_name}-${local.env_name}-eip-${count.index + 1}"
        Description = "Managed by Terraform"
    }
}

resource "aws_nat_gateway" "main" {
    count           = var.subnet_count[terraform.workspace]
    allocation_id   = aws_eip.main[count.index].id
    subnet_id       = aws_subnet.public[count.index].id

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-ngw-${count.index + 1}"
    Description = "Managed by Terraform"
  }

}

##################################################################################
# RESOURCES - SUBNETWORKS (This will create subnetworks with a netmask of 24 bits)
##################################################################################

resource "aws_subnet" "public" {
    count                   = var.subnet_count[terraform.workspace]
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.network_address_space[terraform.workspace], 5, count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-public-subnet-${count.index + 1}"
    Description = "Managed by Terraform"
  }
}

resource "aws_subnet" "private" {
    count                   = var.subnet_count[terraform.workspace]
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.network_address_space[terraform.workspace], 5, count.index + 10)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-private-subnet-${count.index + 1}"
    Description = "Managed by Terraform"
  }
}

resource "aws_subnet" "data" {
    count                   = var.subnet_count[terraform.workspace]
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.network_address_space[terraform.workspace], 5, count.index + 20)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-data-subnet-${count.index + 1}"
    Description = "Managed by Terraform"
  }
}

##################################################################################
# RESOURCES - ROUTE TABLES
##################################################################################

resource "aws_route_table" "public" {
    count   = var.subnet_count[terraform.workspace]
    vpc_id  = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
      Name = "${local.co_name}-${local.biz_name}-${local.env_name}-public-rtb-${count.index + 1}"
      Description = "Managed by Terraform"
  }

  depends_on  = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
    count  = var.subnet_count[terraform.workspace]
    vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
      Name = "${local.co_name}-${local.biz_name}-${local.env_name}-private-rtb-${count.index + 1}"
      Description = "Managed by Terraform"
  }

  depends_on  = [aws_nat_gateway.main]
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count[terraform.workspace]
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = var.subnet_count[terraform.workspace]
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}