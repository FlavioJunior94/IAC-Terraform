variable "project_name" {
  description = "Nome do projeto. Usado para nomear os recursos."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o RDS será criado."
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas para o DB Subnet Group."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR da VPC. Usado para restringir acesso ao banco apenas de dentro da VPC."
  type        = string
}

variable "db_name" {
  description = "Nome do banco de dados inicial."
  type        = string
}

variable "db_username" {
  description = "Usuário administrador do banco."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Senha do usuário administrador do banco."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Classe da instância RDS. Ex: db.t3.micro"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Tamanho do disco em GB."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Tipo de storage EBS. gp2 ou gp3."
  type        = string
  default     = "gp2"
}

variable "multi_az" {
  description = "Habilita réplica em outra AZ para alta disponibilidade."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Se true, não tira snapshot ao destruir. Use true em staging, false em produção."
  type        = bool
  default     = true
}
