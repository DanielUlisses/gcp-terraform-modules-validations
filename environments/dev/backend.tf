terraform {
  backend "gcs" {
    bucket = "pythian-tf-test-tfstate"
    prefix = "env/dev"
  }
}
