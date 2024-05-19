resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "my-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.this.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "my-private-subnet-${count.index}"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "my-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_security_group" "db" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "db-security-group"
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.this.id
}

output "db_security_group_id" {
  value = aws_security_group.db.id
}
