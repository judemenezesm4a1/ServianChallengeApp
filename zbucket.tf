############ Defining S3 bucket #############
# S3 bucket to store .tfstate files. 
#############################################

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-m4a1"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }

# # To encrypt the data in the bucket
  server_side_encryption_configuration {
    rule{
        apply_server_side_encryption_by_default{
            sse_algorithm = "AES256"
        }
    }
  }
}

############# THIS CODE NEEDS TO BE UNCOMMENTED ###################

# # Comment the code below to create the s3 bucket, after Terraform
# # apply is complete, uncomment the code below and do a terraform init,
# # and tarraform apply again, execuring the code below will deploy 
# # .tfstate file in the created S3 bucket. 


# terraform {
#   backend "s3"{
#     bucket = "my-bucket-m4a1"
#     key = "global/s3/terraform.tfstate"
#     region = "ap-southeast-2"
#     encrypt = true
 
#   }
# }