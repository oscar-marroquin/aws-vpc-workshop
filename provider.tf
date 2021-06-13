##################################################################################
# Amazon Web Services Provider
##################################################################################

provider "aws" {
  profile   = "vpc-workshop" /* You can use an AWS Profile instead using AWS Access and Secret Keys. */
  region    = var.region
}