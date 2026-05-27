terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-venky-12345"
    key            = "terraform/state.tfstate"
    region         = "us-west-1"
    //dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}