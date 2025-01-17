terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "state/${terraform.workspace}.tfstate"
    region = "eu-west-1"
  }
}