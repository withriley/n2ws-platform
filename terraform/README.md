<!-- BEGIN_TF_DOCS -->


## Example

```hcl
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
```

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_internet_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [random_string.externalid](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [local_file.assume_role_policy](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.policies](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC you are creating - to use for N2WS resources - make sure this doesn't clash with any VPCs you are creating that you might want to peer with. | `string` | n/a | yes |
| <a name="input_cpm_instance"></a> [cpm\_instance](#input\_cpm\_instance) | The CIDR block defined IP of the CPM instance | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A tag to define where you are deploying your environment to | `string` | `"Development"` | no |
| <a name="input_is_external"></a> [is\_external](#input\_is\_external) | Defines whether the connection is external to a CPM hosted on the internet or another account, or local over VPC peers. Default is True | `bool` | `true` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | A map of rules for security group ingresses | <pre>map(object({<br>    port       = number<br>    protocol   = string<br>    cidr_block = string<br>  }))</pre> | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A map defining subnets for the VPC | <pre>map(object({<br>    cidr_block        = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The Bucket ARN for the bucket that gets used by CPM |
| <a name="output_externalid"></a> [externalid](#output\_externalid) | The ExternalID to be used for STS for the Assume Role policy for CPM |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The Role ARN for the Role that gets assumed by CPM |
<!-- END_TF_DOCS -->