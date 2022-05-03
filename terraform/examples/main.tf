module "n2ws" {
  #source = "github.com/withriley/n2ws-platform/terraform"
  source = "../"

  cidr_block = var.cidr_block # replace CIDR block with your desired CIDR block for the VPC you are creating

  subnets = var.subnets

  environment = var.environment

  cpm_instance = var.cpm_instance # This entry is the CIDR representation of the Cloud Protection Manager Instance

  security_group_rules = {
    rule1 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = var.cpm_instance # This entry is the CIDR representation of the Cloud Protection Manager Instance
    }
    rule2 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = var.cidr_block 
    }
    rule3 = {
      port       = 443
      protocol   = "tcp"
      cidr_block = var.cidr_block
    }
  }
}