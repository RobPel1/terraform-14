resource "aws_vpc" "vpc1" {
    cidr_block = var.vpc-cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"
    tags = {
      Name = "Vpc-resume-app"
      env= "dev"
      Team= "devops"
    }
}

// internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "IGW"
  }
  // depends-on = [ aws_vpc.vpc1 ]
}

#Public Subnet

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-1a"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-1b"
  }
}

#Private Subnet

resource "aws_subnet" "sub3" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private-1a"
  }
}

resource "aws_subnet" "sub4" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private-1b"
  }
}

#NAT Gateway

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.sub1.id

  tags = {
    Name = "gw NAT"
  }
}

// Elastic IP for NAT Gateway

resource "aws_eip" "eip" {
  
}

#Public Route Table

# 1. Create the Route Table 

resource "aws_route_table" "public_rt" { 
    vpc_id = aws_vpc.vpc1.id

    tags = { 
        Name = "public-route-table" 
    } 
} 

# 2. Create a Route (Points all outbound traffic to an Internet Gateway) 

resource "aws_route" "public_internet_route" { 
    route_table_id = aws_route_table.public_rt.id 
    destination_cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.gw.id
}

 # 3. Associate the Route Table with a Subnet 

 resource "aws_route_table_association" "public_subnet_assoc" { 
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_assoc2" { 
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.public_rt.id
}

#Route and Association for private Subnet

# 1. Create the Route Table 

resource "aws_route_table" "private_rt" { 
    vpc_id = aws_vpc.vpc1.id

    tags = { 
        Name = "private-route-table" 
    } 
} 

# 2. Create a Route (Points all outbound traffic to an Internet Gateway) 

resource "aws_route" "private_internet_route" { 
    route_table_id = aws_route_table.private_rt.id 
    destination_cidr_block = "0.0.0.0/0" 
    gateway_id = aws_nat_gateway.nat1.id
}

 # 3. Associate the Route Table with a Subnet 

 resource "aws_route_table_association" "private_subnet_assoc" { 
    subnet_id = aws_subnet.sub3.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_assoc2" { 
    subnet_id = aws_subnet.sub4.id
    route_table_id = aws_route_table.private_rt.id
}


#create sub-domain in route 53
/*
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "terraform.attechrob.com"
  type    = "A"
  ttl     = 300
  records = ["200.10.19.34"]
}
*/