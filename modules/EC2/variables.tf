variable "vpc_id" {
  description = "VPC ID from network module"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs from network module"
  type        = map(string)
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number

  default = 2
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string

  default = "t2.micro"
}

variable "ssh_ip" {
  description = "Allowed IP for SSH access"
  type        = string
}