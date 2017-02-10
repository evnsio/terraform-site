# = = = = = = = = = = = = = = = = =
# AWS Settings:
# = = = = = = = = = = = = = = = = =

# AWS region to use
variable "aws_region" {
  default = "eu-west-1"
}

# Your instances will be tagged with this name
variable "site_name_tag" {
  default = "Terraformed by Evns"
}

# The name of the S3 bucket to be created for backups
variable "backup_bucket_name" {
  default = "backups"
}

# The public ssh key to attach to the instance
variable "public_key" {}


# = = = = = = = = = = = = = = = = =
# Cloudflare settings:
# = = = = = = = = = = = = = = = = =

# Change to true to include cloudflare in setup
variable "configure_cloudflare" {
  default = false
}

# Email address for your Cloudflare account
variable "cloudflare_email" {
  default = "set this value"
}

# Cloudflare token (available in your account)
variable "cloudflare_token" {
  default = "set this value"
}

# The root domain, i.e. "evns.io".   Exclude 'www' etc.
variable "root_domain" {
  default = "set this value"
}

