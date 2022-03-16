variable "cidr_block" {
  description = "The CIDR block to use for N2WS resources - make sure this doesn't clas with anything else in cloud or on-prem"
  type = string
}

variable "security_group_rules" {
  description = "A map of rules for security group ingresses"
  type = map(object({
    port = number
    protocol = string
    cidr_block = string
  }))
}

variable "subnets" {
  description = "A map defining subnets for the VPC"
  type = map(object({
    cidr_block = string
    availability_zone = string
  }))
}

variable "environment" {
  description = "A tag to define where you are deploying your environment to"
  type = string
  default = "Development"
}