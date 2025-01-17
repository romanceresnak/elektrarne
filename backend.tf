terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-rc-el"
    key    = "state/dev.tfstate"
    region = "eu-west-1"
  }
}