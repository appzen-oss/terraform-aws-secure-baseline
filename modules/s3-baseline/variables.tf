variable "enabled" {
  description = "Boolean whether the S3 baseline module should be enabled"
  default     = true
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for buckets in this account. Defaults to true."
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for buckets in this account. Defaults to true."
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for buckets in this account. Defaults to true."
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for buckets in this account. Defaults to true."
  default     = true
}
