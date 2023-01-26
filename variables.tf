variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}
variable "private_subnet_cidrs" {
  description = "VPC private subnets"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}
variable "public_subnet_cidrs" {
  description = "VPC public subnets"
  default = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}
variable "cidrs" {
  description = "VPC network"
  default = "10.0.0.0/16"
}