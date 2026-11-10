variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "engli3m"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC "
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones of VPC"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}