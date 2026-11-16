# RDS Security Group
resource "aws_security_group" "main" {
  name                   = "${var.project_name}-rds-sg"
  description            = "Security group for Engli3m RDS SQL Server"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false

  ingress {
    from_port       = 1433
    to_port         = 1433
    protocol        = "tcp"
    security_groups = [var.eks_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Project     = "Engli3m"
  }
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name        = "${var.project_name}-db-subnet-group"
  description = "Private subnets for Engli3m RDS"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Environment = var.environment
    Project     = "Engli3m"
  }
}

# RDS SQL Server Instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db"
  engine            = "sqlserver-ex"
  engine_version    = "16.00.4305.5.v1"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  storage_encrypted = true

  username = "engli3madmin"

  port = 1433

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.main.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 0

  auto_minor_version_upgrade = true

  deletion_protection = false

  skip_final_snapshot = true

  apply_immediately = false

  tags = {
    Environment = var.environment
    Project     = "Engli3m"
  }

}