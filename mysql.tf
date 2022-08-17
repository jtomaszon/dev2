resource "random_password" "master" {
  length = 16
}

module "aurora" {
  source = "terraform-aws-modules/rds-aurora/aws"

  name           = "local-development"
  engine         = "aurora-mysql"
  engine_version = "5.7"
  instances = {
    1 = {
      instance_class      = "db.r5.large"
      publicly_accessible = true
    }
  }

  vpc_id                 = module.development-vpc.vpc_id
  db_subnet_group_name   = module.development-vpc.database_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = module.development-vpc.private_subnets_cidr_blocks

  iam_database_authentication_enabled = true
  master_password                     = random_password.master.result
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.development.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.development.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  security_group_use_name_prefix = false

}

resource "aws_db_parameter_group" "development" {
  name        = "local-development"
  family      = "aurora-mysql5.7"
  description = "local-development"
}

resource "aws_rds_cluster_parameter_group" "development" {
  name        = "local-development-cluster"
  family      = "aurora-mysql5.7"
  description = "local-development-cluster"
}