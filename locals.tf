# Just some basic housekeeping stuff
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  accountId  = data.aws_caller_identity.current.account_id
  regionName = data.aws_region.current.name
}
