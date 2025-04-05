# terraform/modules/database/main.tf (key components)
resource "aws_db_instance" "main" {
  allocated_storage = var.allocated_storage
  engine = var.db_engine
  instance_class = var.db_instance_class
  identifier = "${var.project_name}-${var.environment}-db"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az = true
  skip_final_snapshot = true
}