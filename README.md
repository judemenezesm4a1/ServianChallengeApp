# 1.  Prerequisites

## 1.1 AWS Account
Need an AWS account, please create one using (https://aws.amazon.com/), create an IAM user and get the access key and private key of that user. 

## 1.2 Installing AWS CLI
Need AWS cli installed on the working system please follow this link (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started) for installation. 
Step 1:
Type aws in the terminal you are using to check if installation is successful, in my case, I am using windows so command prompt. 
Step 2:
Once installation is verified, 
type aws configure and enter the access and the private key generated from AWS. 
Step 3:
Please put ap-southeast-2 as your region as I have done most of the testing on ap-southeast-2. 
Reason, customer data will stay on shore and quick response time. 

## 1.3 Installing Terraform
Need Terraform installed on the testing system please follow the link (https://www.terraform.io/downloads) for installation. 
To check if terraform is properly installed type Terraform -version in your terminal. 

# 2.  How to run the terraform file
## Step 1:
Please clone/download the repository in code editor of your choice. 
I have tested and written the code on Visual Studio Code. 

## Step 2: [**terraform init**]
Once the clone is complete, open the terminal on the IDE and type [terraform init] to initialize the code. 

## Step 3: [**terraform plan**]
Once terraform init is successful, type [terraform plan], this will prompt you for the password for the database, please enter the database credentials and press enter on the keyboard.  

## Step 4: [**terraform apply**]
After terraform plan is complete type [terraform apply], this will again prompt for the database password, please enter the same credentials entered previously and press enter on the keyboard. Please type yes to proceed with the deployment. If the deployment fails, re-run step 4, this should provision the infrastructure properly, please check section 3  for troubleshooting.
Load balancer dns will be popped in the terminal after successful execution, please use the link in any browser of choice for testing purposes.

**NOTE**
_After the deployment is complete, please open zbucket.tf file and uncomment the code section at the bottom and please repeat the above steps. This is to provision the terraform.tfstate file on the S3 bucket, I couldn’t find a better way of provisioning tfstate file to S3. The code will still execute successfully without uncommenting the zbucket code block, but if there is a need to store .tfstate files in a remote location for security purposes, please consider executing the code._  
Please refer to the architecture section to see what infrastructure that is being provisioned.

# 3. Troubleshooting

## 3.1 Execution error
If terraform apply does not work the first time or completes with an error, please re-run the terraform apply command, this will fix the issue. 

## 3.2 503 error
Please put the load balancer dns in the browser after couple minutes, if you still get 503 error please refresh the page. The load balancer takes a while to become live. 

# 4.  Architecture
    Following infrastructure will be deployed:
    1.  S3 bucket
    2.  VPC
    3.  Three subnets in 3 availability zones
    4.  ECS (Elastic Container Services)
    5.  Task definition in ECS
    6.  Fargate
    7.  (ALB) Application Load balancer
    8.  Security group
    9.  IAM group
    10.  Cloud watch
    11.  Autoscaling group
![image](https://user-images.githubusercontent.com/52432393/180317456-b3374833-9f75-456a-8117-89aab9f8f8d5.png)

# 5.  How to destroy the architecture [terraform destroy]

After deploying the infrastructure, the infrastructure can be teared down using the command [terraform destroy]. 
Most of the infrastructure will be destroyed, apart from the s3 bucket if at-all provisioned (will be an error at the end, saying s3 bucket is not empty). S3 bucket needs to be deleted manually. Please navigate and log in to the aws console on the browser of your choice, log in to the console. In the search box, type S3, and click on S3 bucket. Select the Name of s3 bucket (my-bucket-m4a1 in this case) and click on empty bucket. Once the bucket is successfully emptied, press exit button on the top, now you can delete the bucket, on the same page of AWS console.  

# 6. Improvements 

There is a lot of room for improvement in the architecture. Given the resources, RDS can be deployed for database high availability. Route 53 can be configured for high availability. If extra control is required EC2 instance of choice can be deployed to host the frontend of the app. Lot of other architectures can be designed depending on the requirements and nature of the app.
 


