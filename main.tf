# Terraform module which creates S3 Bucket resources for Load Balancer Access Logs on AWS.
#
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html

# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
resource "aws_s3_bucket" "default" {
  # Rules for Bucket Naming
  #   - Bucket names must be unique across all existing bucket names in Amazon S3.
  #   - Bucket names must comply with DNS naming conventions.
  #   - Bucket names must be at least 3 and no more than 63 characters long.
  #   - Bucket names can contain lowercase letters, numbers, and hyphens.
  #   - Bucket names must not contain uppercase characters or underscores.
  #   - Bucket names must start with a lowercase letter or number.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html#bucketnamingrules
  bucket = "${var.name}"

  # S3 access control lists (ACLs) enable you to manage access to buckets and objects.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html
  acl = "private"

  # Server access logging provides detailed records for the requests that are made to a bucket.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html
  logging {
    target_bucket = "${var.logging_target_bucket}"
    target_prefix = "logs/${var.name}/"
  }

  # Versioning is a means of keeping multiple variants of an object in the same bucket.
  # Versioning-enabled buckets enable you to recover objects from accidental deletion or overwrite.
  #
  # Once you version-enable a bucket, it can never return to an unversioned state.
  # You can, however, suspend versioning on that bucket.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html
  versioning {
    enabled = "${var.versioning_enabled}"
  }

  # S3 encrypts your data at the object level as it writes it to disks in its data centers
  # and decrypts it for you when you access it.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/serv-side-encryption.html
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        # The objects are encrypted using server-side encryption with either
        # Amazon S3-managed keys (SSE-S3) or AWS KMS-managed keys (SSE-KMS).
        # https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
        sse_algorithm = "AES256"
      }
    }
  }

  # To manage your objects so that they are stored cost effectively throughout their lifecycle, configure their lifecycle.
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/object-lifecycle-mgmt.html
  lifecycle_rule {
    enabled = "${var.lifecycle_rule_enabled}"
    prefix  = "${var.lifecycle_rule_prefix}"

    # The STANDARD_IA and ONEZONE_IA storage classes are designed for long-lived and infrequently accessed data.
    # https://docs.aws.amazon.com/AmazonS3/latest/dev/storage-class-intro.html#sc-infreq-data-access
    transition {
      days          = "${var.standard_ia_transition_days}"
      storage_class = "STANDARD_IA"
    }

    # The GLACIER storage class is suitable for archiving data where data access is infrequent.
    # https://docs.aws.amazon.com/AmazonS3/latest/dev/storage-class-intro.html#sc-glacier
    transition {
      days          = "${var.glacier_transition_days}"
      storage_class = "GLACIER"
    }

    # For a versioned bucket, there are several considerations that guide how Amazon S3 handles the expiration action.
    #   - The Expiration action applies only to the current version.
    #   - S3 doesn't take any action if there are one or more object versions and the delete marker is the current version.
    #   - If the current object version is the only object version and it is also a delete marker,
    #     S3 removes the expired object delete marker.
    # https://docs.aws.amazon.com/AmazonS3/latest/dev/intro-lifecycle-rules.html
    expiration {
      days = "${var.expiration_days}"
    }

    # Specifies when noncurrent objects transition to a specified storage class.
    # https://docs.aws.amazon.com/AmazonS3/latest/dev/intro-lifecycle-rules.html#intro-lifecycle-rules-actions
    noncurrent_version_transition {
      days          = "${var.glacier_noncurrent_version_transition_days}"
      storage_class = "GLACIER"
    }

    # Specifies when noncurrent object versions expire.
    # https://docs.aws.amazon.com/AmazonS3/latest/dev/intro-lifecycle-rules.html#intro-lifecycle-rules-actions
    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }

  # A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error.
  # These objects are not recoverable.
  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#force_destroy
  force_destroy = "${var.force_destroy}"

  # A mapping of tags to assign to the bucket.
  tags = "${var.tags}"
}

# https://www.terraform.io/docs/providers/aws/r/s3_bucket_policy.html
resource "aws_s3_bucket_policy" "default" {
  bucket = "${aws_s3_bucket.default.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.default.arn}"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.name}/*",
    ]
  }
}

# https://www.terraform.io/docs/providers/aws/d/elb_service_account.html
data "aws_elb_service_account" "default" {}
