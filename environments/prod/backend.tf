terraform {
  backend "gcs" {
    bucket = "dasilva-sandbox-tfstate"
    prefix = "env/prod"
  }
}
