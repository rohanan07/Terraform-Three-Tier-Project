output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.main_vpc.cidr_block
}

output "public_subnet_id" {
  description = "ids of public subnets"
  value = aws_subnet.public_subnets[*].id
}

output "frontend_subnet_id" {
  description = "ids of public subnets"
  value = aws_subnet.frontend_subnets[*].id
}

output "backend_subnet_id" {
  description = "ids of public subnets"
  value = aws_subnet.backend_subnets[*].id
}

output "db_subnet_id" {
  description = "ids of public subnets"
  value = aws_subnet.db_subnets[*].id    
}

output "nat_eip" {
  value = aws_eip.nat_eip[*].public_ip
}