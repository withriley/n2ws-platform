module "n2ws" {
  source = "github.com/withriley/n2ws-platform/terraform"

  cidr_block = var.cidr_block # replace CIDR block with your desired block

  subnets = var.subnets

  cpm_instance = var.cpm_instance

  security_group_rules = {
    rule1 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = var.cpm_instance # This entry points to the IP address of the Cloud Protection Manager Instance
    }
    rule2 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = var.cidr_block # replace with your CIDR block
    }
    rule3 = {
      port       = 443
      protocol   = "tcp"
      cidr_block = var.cidr_block # replace with your CIDR block
    }
  }
}