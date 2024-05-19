resource "aws_db_instance" "this" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "dev-db-instance"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = var.db_subnet_group
}

output "db_instance_endpoint" {
  value = aws_db_instance.this.endpoint
}
