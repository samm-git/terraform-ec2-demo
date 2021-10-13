# Terraform/Cloud9 IaC demo

Purpose of this demo is to show how to create EC2 instances in IaC way using
`terraform` and `cloud9` IDE. This configuration is intentionally simplified,
in the real-life application there will be more blocks, including Load Balance,
Auto Scaling Groups, database servers, etc.


## How to use it

1. Open Cloud9 console and go to the terminal tab
1. Run `git clone https://github.com/samm-git/terraform-ec2-demo.git` to checkout the code.
1. Go to the `terraform-ec2-demo` by typing `cd terraform-ec2-demo`
1. Run `terraform init` to initialise environemnt.
1. Run `terraform plan` and scroll up and read the output. This way you can see what kind of resources Terraform is going to create, delete or modify.
1. Run `terraform apply` and confirm resource creation. This will output HTTP url of the newly created web server. You can open it in the browser in a few minutes, it should show welcome text from the `userdata.yml` file.
1. Open terraform-ec2-demo/main.tf file and increase count from `1` to `2` on the line 46. Save the file.
1. Run `terraform apply` again. You will see that Terraform is going to add one more server. Confirm the run. Server ip addresses will be visible in output and you can connect to the new server in a few minutes.
1. Finally, we can destroy resources created. To cleanup run `terraform destroy` command and confirm resource deletion.

Congratulations, you just finished terraform IaC lab. 
