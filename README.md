1.  Prerequisites
Need an AWS account, create an IAM user and get the access key and private key of that user. 

Need AWS cli installed on the working system please follow this link (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) for installation. 
Type aws in the terminal you are using to check if installation is successful, in my case, I am using windows so command prompt. Once installation is verified, type aws configure, and enter the access and the private key generated from AWS. Please put ap-southeast-2 as your region as I have done most of the testing on ap-southeast-2. Reason, customer data will stay on shore and quick response time. 

Need Terraform installed on the testing system please follow the link (https://www.terraform.io/downloads) for installation. To check if terraform is properly installed type Terraform -version in your terminal. 

2.  How to run the terraform file
Please clone the repository in code editor of your choice. I have tested and written the code on Visual Studio Code. 
Once the clone is complete, type terraform init to initialize the code. Once terraform init is successful type terraform plan, this will prompt you for the password for the database, please enter the database credentials.  After terraform plan is complete type terraform apply, this will again prompt for the database password, please enter the same credentials entered previously. Please type yes to proceed with the deployment. 
After the deployment is complete, please open zbucket.tf file and uncomment the code section at the bottom and please repeat the above steps. This is to provision the terraform.tfstate file on the S3 bucket, I couldn’t find a better way of provisioning tfstate file to S3. The code will still execute successfully without uncommenting the zbucket code block, but the if there is a need to store .tfstate files in a remote location for security purposes, please consider executing the code.  
Please refer to the architecture to see what infrastructure is being provisioned. 

3.  Architecture
    Following infrastructure will be deployed:
    ->  S3 bucket
    ->  VPC
    ->  Three subnets in 3 availability zones
    ->  ECS (Elastic Container Services)
    ->  Task definition in ECS
    ->  Fargate
    ->  (ALB) Application Load balancer
    ->  Security group
    ->  IAM group
    ->  Cloud watch
    ->  Autoscaling group
![image](https://user-images.githubusercontent.com/52432393/180317456-b3374833-9f75-456a-8117-89aab9f8f8d5.png)

4.  How to destroy the architecture
After deploying the infrastructure, the infrastructure can be teared down using the command terraform destroy. 
Most of the infrastructure will be destroyed, apart from the s3 bucket (will be an error at the end, saying s3 bucket is not empty). S3 bucket needs to be deleted manually. Please navigate and log in to the aws console on the browser of your choice. In the search box, type S3, and click on S3 bucket. Select the Name of s3 bucket (my-bucket-m4a1) and click on empty bucket. Once the bucket is successfully emptied, you can delete the bucket, on the same page of AWS console.  

5. Trouble Shooting
If terraform apply does not work the first time or completes with an error, please re-run the terraform apply command, this will fix the issue. 


