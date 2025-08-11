# ---------------------------------------------------------------------------------------------------------------------
# ¦ PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
# NOTE: make sure to setup AWS credentials in your environment
# e.g. export AWS_ACCESS_KEY_ID=your_access_key_id
# e.g. export AWS_SECRET_ACCESS_KEY=your_secret_access_key
provider "aws" {
  region = "eu-central-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ VERSIONS
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  # 1.8.9 is the latest version of OpenTofu where this example works without issues
  # 1.9.0 and later versions of OpenTofu will cause an error on destroy
  # Terraform is not affected by this issue
  required_version = ">= 1.8.9"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = []
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ DATA
# ---------------------------------------------------------------------------------------------------------------------
# this is just a simple example of this usage pattern of reading existing resources and passing them to a module
# in this case, we read all IAM role names and then get the details of each role via a data source with for_each
data "aws_iam_roles" "all" {}
data "aws_iam_role" "details" {
  for_each = {
    for role in data.aws_iam_roles.all.names : role => role
  }
  name = each.value
}

# ---------------------------------------------------------------------------------------------------------------------
# ¦ DUMMY MODULE
# ---------------------------------------------------------------------------------------------------------------------
module "dummy_module" {
  source = "./modules/dummy"

  # NOTE: 'OrganizationAccountAccessRole' is only available if account is part of an AWS Organization (replace otherwise)
  dummy_string = data.aws_iam_role.details["OrganizationAccountAccessRole"].arn
}