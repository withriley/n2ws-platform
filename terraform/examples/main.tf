module "n2ws-platform" {
  source = "../"

  cidr_block = "10.230.230.0/24" # replace CIDR block with your desired block

  subnets = {
    n2ws-subnet-a = {
      cidr_block        = "10.230.230.0/25" # replace these also
      availability_zone = "ap-southeast-2a"
    }
    n2ws-subnet-b = {
      cidr_block        = "10.230.230.128/25" # replace these also
      availability_zone = "ap-southeast-2b"
    }
  }

  cpm_instance = "52.63.255.188/32"

  security_group_rules = {
    rule1 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = "52.63.255.188/32" # This entry points to the IP address of the Cloud Protection Manager Instance
    }
    rule2 = {
      port       = 22
      protocol   = "tcp"
      cidr_block = "10.230.230.0/24" # replace with your CIDR block
    }
    rule3 = {
      port       = 443
      protocol   = "tcp"
      cidr_block = "10.230.230.0/24" # replace with your CIDR block
    }
  }
}