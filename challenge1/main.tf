provider "aws" {
  region = "us-west-1"
}

module "vpc" {
   source = "terraform-aws-modules/vpc/aws"
   name = "kpmgvpc"
   cidr = "10.0.0.0/16"
   azs             = ["us-west-1a", "us-west-1b"]
   public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   enable_ipv6 = true
   enable_nat_gateway = false
   single_nat_gateway = true
   public_subnet_tags = {
    Name = "Public-Subnets"
   }
   tags = {
    Owner       = "kpmg-user"
    Environment = "kpmg"
   }
   vpc_tags = {
    Name = "kpmg-vpc"
   }
}

# Create a database server
resource "aws_db_instance" "kpmg-db" {
   allocated_storage = 5
   engine         = "mysql"
   engine_version = "8.0.20"
   instance_class = "db.t3.micro"
   name           = "initial_db"
   username       = "kpmg-user"
   password       = "kpmgpassword"
}

# Create an Network Load Balancer
resource "aws_lb" "kpmg-NLB" {
   name = "kpmg-NLB"
   internal = false
   load_balancer_type = "network"
   subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   enable_deletion_protection = false
}
