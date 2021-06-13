##################################################################################
# Minimal Security Groups rules to allow SSH and RDP from your own Public IP
##################################################################################

# Grabbing the Public IP of our Cloud Architect ;)
data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
}

# Allowing connections from your own Public IP to manage Linux and Windows VM's.
resource "aws_security_group" "allow-ssh-from-own-public-ip" {
    name        = "${local.co_name}-${local.biz_name}-${local.env_name}-internet-internal-tcp-22-allow-rule"
    description = "Allow SSH from Internet to the Internal IP addresses on your VPC Network"
    vpc_id      = aws_vpc.main.id

    ingress {
        description      = "Allow SSH from my own Public IP address"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${local.ifconfig_co_json.ip}/32"]
    }

    tags = {
        Name        = "${local.co_name}-${local.biz_name}-${local.env_name}-internet-internal-tcp-22-allow-rule"
        Description = "Managed by Terraform"
    }
}

resource "aws_security_group" "allow-rdp-from-own-public-ip" {
    name = "${local.co_name}-${local.biz_name}-${local.env_name}-internet-internal-tcp-3389-allow-rule"
    description = "Allow RDP from Internet to the Internal IP addresses on your VPC Network"
    vpc_id      = aws_vpc.main.id

    ingress {
        description      = "Allow RDP from my own Public IP address"
        from_port        = 3389
        to_port          = 3389
        protocol         = "tcp"
        cidr_blocks      = ["${local.ifconfig_co_json.ip}/32"]
    }

    tags = {
        Name        = "${local.co_name}-${local.biz_name}-${local.env_name}-internet-internal-tcp-3389-allow-rule"
        Description = "Managed by Terraform"
    }
}

# Allowing connections to internet
resource "aws_security_group" "allow-internet-from-my-vpc-resources" {
    name        = "${local.co_name}-${local.biz_name}-${local.env_name}-internal-internet-all-traffic-allow-rule"
    description = "Allow SSH from Internet to the Internal IP addresses on your VPC Network"
    vpc_id      = aws_vpc.main.id

    egress {
        description = "Allow Internet access from my VPC resources"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "${local.co_name}-${local.biz_name}-${local.env_name}-internal-internet-all-traffic-allow-rule"
        Description = "Managed by Terraform"
    }
}
