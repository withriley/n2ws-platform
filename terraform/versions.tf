provider "aws" {
  default_tags {
    tags = {
      Environment = "testing"
      Owner       = "emile"
      Name = "N2WS"
    }
  }
  region = "ap-southeast-2"

  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn    = "arn:aws:iam::580110857053:role/riley-admin"
  }
}