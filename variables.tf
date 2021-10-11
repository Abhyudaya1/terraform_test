variable "project_name" {
  type = string
  description = "Enter the project name"
  default = "Project 0"
}

locals {
  service_configuration = jsondecode(file("service_configuration.json")).service_configuration
}

variable "dbbuser" {
  type = string
  description = "Enter the db user name"
  default = "animaluser"
}

variable "mongdbatlas_project_id" {
  type = string
  description = "Enter the project id of the mongo db"
  default = "5fc1688708c77a31a79f2bb6"
}


data "mongodbatlas_clusters" this {
  project_id = var.mongdbatlas_project_id 
}

data mongodbatlas_cluster this {
  for_each = toset(data.mongodbatlas_clusters.this.results[*].name)

  project_id = var.mongdbatlas_project_id
  name       = each.value
}

output "connection_strings" {
  value = data.mongodbatlas_clusters.this.results[0].connection_strings.0.standard_srv
}

resource random_password store-service-password {
  length           = 9
  special          = false
}

// Making an user
resource "mongodbatlas_database_user" "test" {
  username           = var.dbbuser
  password           = random_password.store-service-password.result
  project_id         = var.mongdbatlas_project_id
  auth_database_name = "admin"

  dynamic "roles" {
    for_each = local.service_configuration
    content {
      role_name       = "read"
      database_name   = roles.value.mongoDatabase
      collection_name = roles.value.mongoCollection
    }
  }
}