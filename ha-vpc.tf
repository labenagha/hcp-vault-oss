module "vpc" {
  source                  = "git::https://github.com/arerepadelouisbenagha/terraform-vpc-module.git?ref=v2.0.0"
  name                    = "ha-dev-vault-vpc"
  security_group_name     = "ha-dev-vault-sg"
  description             = "security for infrastructure"
  cidr_block              = "10.0.0.0/16"
  enable_dns_support      = true
  instance_tenancy        = "default"
  public_subnets          = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets         = []
  map_public_ip_on_launch = true
  azs                     = ["us-east-1a", "us-east-1b"]

  security_group_ingress = [
    {
      description = "HA Vault access from VPC"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "143.55.59.117/32"
    }
  ]

  security_group_egress = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev-vault"
  }
}