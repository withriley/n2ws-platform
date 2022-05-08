<!-- BEGIN_TF_DOCS -->


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_n2ws"></a> [n2ws](#module\_n2ws) | ../ | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block to use for N2WS resources - make sure this doesn't clas with anything else in cloud or on-prem | `string` | n/a | yes |
| <a name="input_cpm_instance"></a> [cpm\_instance](#input\_cpm\_instance) | The CIDR block defined IP of the CPM instance | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | A tag to define where you are deploying your environment to | `string` | `"Development"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A map defining subnets for the VPC | <pre>map(object({<br>    cidr_block = string<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The Bucket ARN for the bucket that gets used by CPM |
| <a name="output_externalid"></a> [externalid](#output\_externalid) | The ExternalID to be used for STS for the Assume Role policy for CPM |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The Role ARN for the Role that gets assumed by CPM |
<!-- END_TF_DOCS -->