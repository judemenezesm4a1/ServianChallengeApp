### Variable for default region ###
variable "region" {
    type = string
    description = "aws region where the infrastructure will be provisioned"
    default = "ap-southeast-2"
}

### Variables for the Database ###
variable "dbhost" {
  type = string
  description = "Enter Database Host"
  default = "localhost"
}
variable "postgres_user" {
  type = string
  description = "Enter Database username"
  default = "postgres" 
  }
variable "postgres_password" {
  type = string
  description = "Enter Database password"
}

