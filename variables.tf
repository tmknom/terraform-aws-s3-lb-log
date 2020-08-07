variable "name" {
  type        = string
  description = "The name of the bucket, which must comply with DNS naming conventions."
}

variable "logging_target_bucket" {
  type        = string
  description = "The name of the bucket that will receive the log objects."
}

variable "versioning_enabled" {
  default     = true
  type        = string
  description = "Enable versioning. Versioning is a means of keeping multiple variants of an object in the same bucket."
}

variable "lifecycle_rule_enabled" {
  default     = true
  type        = string
  description = "Specifies lifecycle rule status."
}

variable "lifecycle_rule_prefix" {
  default     = ""
  type        = string
  description = "Object key prefix identifying one or more objects to which the rule applies."
}

variable "standard_ia_transition_days" {
  default     = "30"
  type        = string
  description = "Specifies a period in the object's STANDARD_IA transitions."
}

variable "glacier_transition_days" {
  default     = "60"
  type        = string
  description = "Specifies a period in the object's Glacier transitions."
}

variable "expiration_days" {
  default     = "90"
  type        = string
  description = "Specifies a period in the object's expire."
}

variable "glacier_noncurrent_version_transition_days" {
  default     = "30"
  type        = string
  description = "Specifies when noncurrent object versions transitions."
}

variable "noncurrent_version_expiration_days" {
  default     = "60"
  type        = string
  description = "Specifies when noncurrent object versions expire."
}

variable "force_destroy" {
  default     = false
  type        = string
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the bucket."
}
