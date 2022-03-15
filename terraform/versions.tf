provider "aws" {
  default_tags {
    tags = {
      Environment = ""
      Owner       = ""
    }
  }
  region = "ap-southeast-2"
}