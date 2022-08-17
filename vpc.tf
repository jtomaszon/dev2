module "development-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "development-vpc"
  cidr = "10.0.0.0/16"

  azs              = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets   = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]


  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "Development"
  }
}