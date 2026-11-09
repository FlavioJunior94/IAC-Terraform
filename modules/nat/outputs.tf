output "nat_gateway_id" {
  description = "ID do NAT Gateway criado."
  value       = aws_nat_gateway.main.id
}

output "elastic_ip" {
  description = "Endereço IP público do Elastic IP associado ao NAT Gateway."
  value       = aws_eip.nat.public_ip
}
