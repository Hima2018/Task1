# Internet Gateway
resource "aws_internet_gateway" "sh_gw" {
  vpc_id = aws_vpc.sh_main.id
}


# Elastic IP for NAT gateway
resource "aws_eip" "sh_eip" {
  depends_on = [aws_internet_gateway.sh_gw]
  vpc        = true
  tags = {
    Name = "sh_EIP_for_NAT"
  }
}

# NAT gateway for private subnets - for the private subnet to access internet

resource "aws_nat_gateway" "sh_nat_for_private_subnet" {
  allocation_id = aws_eip.sh_eip.id
  subnet_id     = aws_subnet.sh_subnet_1.id // nat should be in public subnet

  tags = {
    Name = "Sh NAT for private subnet"
  }
 
  depends_on = [aws_internet_gateway.sh_gw]
}