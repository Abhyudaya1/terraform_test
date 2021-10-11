
terraform {
  required_version = ">= 0.13"
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.0.2"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }    
  }
}

