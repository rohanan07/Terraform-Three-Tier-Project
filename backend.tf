terraform {
  backend "s3" {
    bucket = "terraform-state-file-rohan-1234"
    key = "three tier project/terraform.tfstate"
    encrypt = true
    use_lockfile = true
    region = "ap-south-1"
  }
}