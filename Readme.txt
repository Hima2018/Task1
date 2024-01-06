Initialise Project:
Created an empty project directory and created a file called main.tf within it.
You can use Access and Secret keys in the provider section
we have to initialise Terraform to use it. (This command will download/update the providers).

terraform init


I have created a VPC with 3 subnets (2 — public, 1 — private) across the region as,

a public subnet in us-east-1a
a public subnet in us-east-1b
a private subnet in us-east-1b


created VPC and subnets

We create subnets using the aws_subnet resource by providing,

the VPC id

Route tables and Gateways
Gateway for public subnets
created load balancer open to the internet, we will place it in the public subnet. We also need an Internet Gateway for the public subnet.

We can create a route table for our public subnet to connect it to Internet Gateway.

Internet gateway for the public subnets
Note: aws_route_table_association resource is used to associate the route table to a subnet.

2. Gateway for Private Subnet
created EC2 instances in the private subnet, allowing only the requests from the load balancer to reach the instances.

But, the instances might need to connect to the internet to download software/tools. To provide access to the internet, we need a NAT gateway for the private subnet.

The NAT instance must have internet access, So, it must be in a public subnet (a subnet that has a route table with a route to the internet gateway), and it must have a public IP address or an Elastic IP address.


Creating a route table and associating it with the subnet is the same process as the previous one.


NAT gateway for the private subnet
Configuring the Load Balancer
We will be creating an application load balancer for our web application, to handle HTTP and HTTPS requests.

provided a public subnet(s) for our load balancer, since we need it to be internet-facing.

Creating the Auto Scaling Group
We will be creating and using an EC2 Launch Template to create EC2 instances.


In the launch template, we are providing,

—the AMI we are going to use (make sure to get the AMI id from the same region as the EC2 instance)
— the instance type
— user data script (base64 encoded file which has commands to start Apache web server)
— security group, subnet id for network configurations.


For the Auto scaling group,

Configuring the capacity:
max_size represents the maximum number of instances that the auto scaling group (ASG) can have, setting a limit to prevent excessive resource usage or costs.
min_size sets the minimum number of instances that the group should always have, ensuring a baseline capacity during low demand.
desired capacity is the desired number of instances that the ASG should aim to have at any given time. It represents the ideal number of instances to handle the current workload.
We can connect this Auto Scaling Group to the Load Balancer target group using target_group_arns.

We add the launch template we created and also the private subnet.


Auto Scaling group with Launch template
My user data file: (to run Web server)
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
Security access rules — for EC2 and Load Balancer
Let’s create a security group each for load balancer and the EC2 instances.

For the Load Balancer, we are allowing HTTP and HTTPS requests from the internet.

For the EC2 instances, we allow only HTTP requests from the load balancer.

Security groups for ELB and EC2
Terraform apply
