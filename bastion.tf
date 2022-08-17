module "bastion-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "bastion-sg"
  description = "Security group for development"
  vpc_id      = module.development-vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_rules        = ["all-all"]
}

module "bastion" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "bastion"
  instance_count         = 1

  ami                    = "ami-02f3416038bdb17fb"
  instance_type          = "t2.micro"
  key_name               = "cfoffload"
  monitoring             = true
  vpc_security_group_ids = [ "${module.development-sg.security_group_id}" ]
  subnet_id              = "${module.development-vpc.public_subnets[0]}"

  associate_public_ip_address = true

  enable_volume_tags = true
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
    },
  ]

  tags = {
    Application   = "bastion"
  }
}

resource "aws_key_pair" "cfoffload" {
    key_name = "cfoffload"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCGDLzYiiIBpmstI1JpvkSZUM9O4XGs90EKEVEsBQvHspti1q5NL+vPzq5+Fi17YJSolO4lFTtp4U0FfPRjwTK2w+k6Lz878jpK5PuSmmr3MwAiXyytTv2L4yplRFpPyafEvw+VrAxunIh+AZkbaZ+7xFUYecP9YjgTY837GBTp1l79br9XYHsLTR0/67efMyUy2WEP7XHlmkwMpjpAfEFtf7fZNpM5UumJ6Eb6YBNLc7lrI0obMzlhfWBiGSABk9io6qEHZLEKudvSrAXH/jgWSSklkYWerg28JmU0J0zkDDD5GRnkzXV+isA2fLpXzjsZdybeL8C34PFxnM2OrpEr"
}

resource "aws_eip" "bastion" {
  instance = "${module.bastion.id[0]}"
  vpc      = true
}
