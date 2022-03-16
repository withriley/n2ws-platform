provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = "RileySolutions"
      Name        = "N2WS"
    }
  }
  region = "ap-southeast-2"
}