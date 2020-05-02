module "s3_lb_log" {
  source                = "../../"
  name                  = "s3-lb-log-${random_id.suffix.dec}"
  logging_target_bucket = "s3-access-log"
}

resource "random_id" "suffix" {
  byte_length = 8
}
