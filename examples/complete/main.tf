module "s3_lb_log" {
  source                = "../../"
  name                  = "s3-lb-log-${random_id.suffix.dec}"
  logging_target_bucket = module.s3_access_log.s3_bucket_id

  versioning_enabled = false
  force_destroy      = true

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

module "s3_access_log" {
  source  = "tmknom/s3-access-log/aws"
  version = "2.0.0"

  name          = "s3-access-log-${random_id.suffix.dec}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 8
}
