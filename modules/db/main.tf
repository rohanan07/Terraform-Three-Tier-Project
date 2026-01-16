resource "aws_db_subnet_group" "main" {
  name = "main-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    name = "three-tier-project-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "main" {
  name = "three-tier-project-pg15"
  family = "postgres15"
  parameter {
    name = "log_connections"
    value = 1
  }
  parameter {
    name = "log_disconnections"
    value = 1
  }
  parameter {
    name = "log_duration"
    value = 1
  }
  tags = {
    name = "three-tier-project-pg15"
  }
}

resource "aws_db_instance" "main" {
  identifier = "three-tier-project-postgres"
  engine = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_encrypted = true
  storage_type = "gp3"

  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  port = 5432

  vpc_security_group_ids = [ var.security_group_id ]
  db_subnet_group_name = aws_db_subnet_group.main.name
  parameter_group_name = aws_db_parameter_group.main.name

  multi_az = var.multi_az
  publicly_accessible = false
  availability_zone = var.availability_zone

  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "three-tier-project-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  monitoring_interval             = var.monitoring_interval
  auto_minor_version_upgrade = true
  deletion_protection        = var.deletion_protection

  tags = {
    name = "three-tier-project-postgres"
  }
}