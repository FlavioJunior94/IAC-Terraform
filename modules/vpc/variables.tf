variable "project_name" {
  description = "Nome do projeto. Usado para nomear os recursos."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC. Ex: 10.0.0.0/16"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs para as subnets públicas. Um por AZ."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs para as subnets privadas. Um por AZ."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "Lista de AZs onde as subnets serão criadas."
  type        = list(string)
}
