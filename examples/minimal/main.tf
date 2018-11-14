module "s3_lb_log" {
  source                = "../../"
  name                  = "s3-lb-log"
  logging_target_bucket = "s3-access-log"
}
