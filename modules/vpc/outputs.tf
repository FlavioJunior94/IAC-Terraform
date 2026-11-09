output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas."
  value       = aws_subnet.private[*].id
}

output "private_route_table_id" {
  description = "ID da route table privada. Usada pelo módulo nat para adicionar a rota do NAT Gateway."
  value       = aws_route_table.private.id
}
