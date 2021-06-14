# aws-vpc-workshop
Launch an AWS VPC Network following the cloud best practices using Terraform.


## Creating a custom VPC Network following the AWS Cloud Best Practices
In this template we'll deploy a custom VPC with multiples subnets and security group rules. You don't need to be an expert of networking and subnetting, this template help you to do that and with the plus that all the tagging strategy it align with some variables that you can modify. This template was created following and using the [Tagging AWS Resources - Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html).


## What file I need modify to use this template
Are only 1 file that you need modify, and this file is the **terraform.tfvars**:

- [X] region - by default I set the "us-east-1" region, but you can use your favorite.
- [ ] company_name - set the real name of your Company.
- [ ] business_unit - set the name of the business unit or application name that will use this network.
- [ ] \(Optional) network_address_space - If you want, you can change the network address space.
- [ ] \(Optional) subnet_count - As well, you can create more than the default subnets that this template creates.

:warning: :warning: :warning: Remember, I encourage to you don't use an **AWS access and secret keys** because this can be insecure, instead my recommendation is to use an AWS profile that previously you need to set in your laptop or PC.


## AWS Login Profile
You'll need to install the [AWS CLI](https://aws.amazon.com/es/cli/) into your laptop or PC to securily use Terraform and deploy resources without hardcoding an **AWS access and secret keys**.

Before to initiated using the Terraform, you'll need to configure and set a custom profile into your laptop or PC. You can use the next CLI command to do that:

**aws configure profile <my-custom-profile>**

After that you'll need to set this profile in the **provider.tf** file and here we go!!!


## Terraform Workspace
This template require that you use a Terraform Workspace, Why? Well, remember that this template is builded to follow the AWS VPC best practices and this best practices tell us that we need identify the "environmment" of our resources.

What are the valid Terraform Workspaces names for this template?

- sbx / for Sandbox Environment
- dev / for Development Environment
- uat / for UAT Environment
- prd / for Production Environment

⭐⭐⭐ And, that's all dudes... you're ready to deploy your custom AWS VPC Network!!! ⭐⭐⭐


## What about the Security Groups and Network ACL's
This template creates 3 Security Groups, 2 of them apply to all resources that needs RDP or SSH management access from internet (with a custom source Public IP address, actually your own Public IP address) and the other one to allow the network traffic to internet. Remember that you'll need apply implicitly this Security Groups to your resources.

And, about Network ACL's we deploy a NACL per-subnet where, for public tier we allow all inbound and outbound traffic from internet (0.0.0.0/0), for the private tier we allow all the inbound traffic for the VPC CIDR and all outbound traffic to internet (0.0.0.0/0) and finally, for the data tier we allow all inbound and outbound traffic from the VPC CIDR only. This is an **AWSome** feature to add an additional security layer to our resources.


## Conclusion
I hope this template is very useful for you, as it's for me. I'd love to hear feedback and suggestions for revisions.

Oscar
