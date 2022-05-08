variable "is_external"{
  type = bool 
  description = "Defines whether the connection is external to a CPM hosted on the internet or another account, or local over VPC peers. Default is True"
  default = true
}

variable "cidr_block" {
  description = "The CIDR block for the VPC you are creating - to use for N2WS resources - make sure this doesn't clash with any VPCs you are creating that you might want to peer with."
  type        = string
}

variable "security_group_rules" {
  description = "A map of rules for security group ingresses"
  type = map(object({
    port       = number
    protocol   = string
    cidr_block = string
  }))
}

variable "subnets" {
  description = "A map defining subnets for the VPC"
  type = map(object({
    cidr_block        = string
  }))
}

variable "environment" {
  description = "A tag to define where you are deploying your environment to"
  type        = string
  default     = "Development"
}

variable "cpm_instance" {
  description = "The CIDR block defined IP of the CPM instance"
  type        = string
}

variable "trust_relationship" {
  description = "The AWS Account ID of the account that hosts the CPM and will need access into the policies"
}