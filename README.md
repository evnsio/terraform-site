# Terraform Site

## Prerequisites

* Install terraform
* Setup your AWS credentials (environment variables or profile in `~/.aws/credentials`)

## Configuration

All the configurable variables are stored in variables.tf.  
To set these variables, either edit them in place or create a new file called `terraform.tfvars` and put your variable definitions in there.
The advantage of this approach is that the tfvars file won't be version controlled so carries less risk of exposing secrets/config.

See [here](https://www.terraform.io/intro/getting-started/variables.html) for details.

## Running

To create the site framework, simply run `terraform plan` to see what will be changed/added and then `terraform apply` to actually provision the resources.