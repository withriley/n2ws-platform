cidr_block = "10.230.230.0/24"

subnets = {
  n2ws-subnet-a = {
    cidr_block        = "10.230.230.0/25"
    availability_zone = "ap-southeast-2a"
  }
  n2ws-subnet-b = {
    cidr_block        = "10.230.230.128/25"
    availability_zone = "ap-southeast-2b"
  }
}

security_group_rules = {
  rule1 = {
    port       = 22
    protocol   = "tcp"
    cidr_block = "52.63.255.188/32"
  }
  rule3 = {
    port       = 443
    protocol   = "tcp"
    cidr_block = "10.230.230.0/24"
  }
}