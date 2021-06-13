# Allow all traffic from incoming and outgoing traffic
resource "aws_network_acl" "public" {
  count  = var.subnet_count[terraform.workspace]
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-public-nacl"
    Description = "Managed by Terraform"
  }

  subnet_ids    =   ["${aws_subnet.public[count.index].id}"]
}

# Allowing incoming traffic from our VPC CIDR
resource "aws_network_acl" "private" {
  count  = var.subnet_count[terraform.workspace]
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = var.network_address_space[terraform.workspace]
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-private-nacl"
    Description = "Managed by Terraform"
  }

  subnet_ids    =   ["${aws_subnet.private[count.index].id}"]
}

# Allowing incoming and outgoing traffic from and to our VPC CIDR
resource "aws_network_acl" "data" {
  count  = var.subnet_count[terraform.workspace]
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = var.network_address_space[terraform.workspace]
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 10000
    action     = "allow"
    cidr_block = var.network_address_space[terraform.workspace]
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${local.co_name}-${local.biz_name}-${local.env_name}-data-nacl"
    Description = "Managed by Terraform"
  }

  subnet_ids    =   ["${aws_subnet.data[count.index].id}"]
}