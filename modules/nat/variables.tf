variable "project_name" {
  description = "Nome do projeto. Usado para nomear os recursos."
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet pública onde o NAT Gateway será criado."
  type        = string
}

variable "private_route_table_id" {
  description = "ID da route table privada. A rota para o NAT Gateway será adicionada aqui."
  type        = string
}
