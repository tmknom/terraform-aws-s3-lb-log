# terraform-aws-s3-lb-log

[![CircleCI](https://circleci.com/gh/tmknom/terraform-aws-s3-lb-log.svg?style=svg)](https://circleci.com/gh/tmknom/terraform-aws-s3-lb-log)
[![GitHub tag](https://img.shields.io/github/tag/tmknom/terraform-aws-s3-lb-log.svg)](https://registry.terraform.io/modules/tmknom/s3-lb-log/aws)
[![License](https://img.shields.io/github/license/tmknom/terraform-aws-s3-lb-log.svg)](https://opensource.org/licenses/Apache-2.0)

Terraform module which creates S3 Bucket resources for Load Balancer Access Logs on AWS.

## Description

Provision [S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html) bucket
designed for [Load Balancer Access Logs](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html).
This module provides recommended settings.

- Enable Access Logging
- Enable Default Encryption
- Enable Versioning
- Enable Lifecycle Configuration
- Protected from deletion

## Usage

### Minimal

```hcl
module "s3_lb_log" {
  source                = "git::https://github.com/tmknom/terraform-aws-s3-lb-log.git?ref=tags/1.1.0"
  name                  = "s3-lb-log"
  logging_target_bucket = "s3-access-log"
}
```

### Complete

```hcl
module "s3_lb_log" {
  source                = "git::https://github.com/tmknom/terraform-aws-s3-lb-log.git?ref=tags/1.1.0"
  name                  = "s3-lb-log"
  logging_target_bucket = "s3-access-log"

  versioning_enabled = false
  force_destroy      = true

  region = "us-west-1"

  lifecycle_rule_enabled                     = true
  lifecycle_rule_prefix                      = ""
  standard_ia_transition_days                = "60"
  glacier_transition_days                    = "90"
  expiration_days                            = "180"
  glacier_noncurrent_version_transition_days = "60"
  noncurrent_version_expiration_days         = "90"

  tags = {
    Environment = "prod"
    Name        = "s3-lb-log"
  }
}
```

## Examples

- [Minimal](https://github.com/tmknom/terraform-aws-s3-lb-log/tree/master/examples/minimal)
- [Complete](https://github.com/tmknom/terraform-aws-s3-lb-log/tree/master/examples/complete)

## Inputs

| Name                                       | Description                                                                                                               |  Type  | Default | Required |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- | :----: | :-----: | :------: |
| logging_target_bucket                      | The name of the bucket that will receive the log objects.                                                                 | string |    -    |   yes    |
| name                                       | The name of the bucket, which must comply with DNS naming conventions.                                                    | string |    -    |   yes    |
| expiration_days                            | Specifies a period in the object's expire.                                                                                | string |  `90`   |    no    |
| force_destroy                              | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. | string | `false` |    no    |
| glacier_noncurrent_version_transition_days | Specifies when noncurrent object versions transitions.                                                                    | string |  `30`   |    no    |
| glacier_transition_days                    | Specifies a period in the object's Glacier transitions.                                                                   | string |  `60`   |    no    |
| lifecycle_rule_enabled                     | Specifies lifecycle rule status.                                                                                          | string | `true`  |    no    |
| lifecycle_rule_prefix                      | Object key prefix identifying one or more objects to which the rule applies.                                              | string | `` | no |
| noncurrent_version_expiration_days         | Specifies when noncurrent object versions expire.                                                                         | string |  `60`   |    no    |
| region                                     | (Optional) If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee.           | string | `` | no |
| standard_ia_transition_days                | Specifies a period in the object's STANDARD_IA transitions.                                                               | string |  `30`   |    no    |
| tags                                       | A mapping of tags to assign to the bucket.                                                                                |  map   |  `{}`   |    no    |
| versioning_enabled                         | Enable versioning. Versioning is a means of keeping multiple variants of an object in the same bucket.                    | string | `true`  |    no    |

## Outputs

| Name                     | Description                                                            |
| ------------------------ | ---------------------------------------------------------------------- |
| s3_bucket_arn            | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname.      |
| s3_bucket_domain_name    | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| s3_bucket_hosted_zone_id | The Route 53 Hosted Zone ID for this bucket's region.                  |
| s3_bucket_id             | The name of the bucket.                                                |
| s3_bucket_region         | The AWS region this bucket resides in.                                 |

## Development

### Development Requirements

- [Docker](https://www.docker.com/)

### Configure environment variables

```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=ap-northeast-1
```

### Installation

```shell
git clone git@github.com:tmknom/terraform-aws-s3-lb-log.git
cd terraform-aws-s3-lb-log
make install
```

### Makefile targets

```text
apply-complete                 Run terraform apply examples/complete
apply-minimal                  Run terraform apply examples/minimal
check-format                   Check format code
clean                          Clean .terraform
destroy-complete               Run terraform destroy examples/complete
destroy-minimal                Run terraform destroy examples/minimal
diff                           Word diff
docs                           Generate docs
format                         Format code
help                           Show help
install                        Install requirements
lint                           Lint code
plan-complete                  Run terraform plan examples/complete
plan-minimal                   Run terraform plan examples/minimal
release                        Release GitHub and Terraform Module Registry
upgrade                        Upgrade makefile
```

### Releasing new versions

Bump VERSION file, and run `make release`.

### Terraform Module Registry

- <https://registry.terraform.io/modules/tmknom/s3-lb-log/aws>

## License

Apache 2 Licensed. See LICENSE for full details.
