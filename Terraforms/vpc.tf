#Step 1 : Create a VPC 
resource "aws_vpc" "myvpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name   = "MyTerraformVPC"
    }
}

#Step 2 : create a private subnet
resource "aws_subnet" "PrivateSubnet"{
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    
    tags = {
        Name = "Private-subnet"
    }
}


#Step 3: Create a public subnet 
resource "aws_subnet" "Public_Subnet_1"{
    vpc_id = aws_vpc.myvpc.id 
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"

    tags = {
        Name = "Public-subnet"
    }
}

resource "aws_subnet" "Public_Subnet_2"{
    vpc_id = aws_vpc.myvpc.id 
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1c"

    tags = {
        Name = "Public-subnet"
    }
}


#Step 4 : create IGW 
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.myvpc.id
}

#Step 5 : route tables for public subnet 
resource "aws_route_table" "Public_RT"{
    vpc_id = aws_vpc.myvpc.id 
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

#Step 6 : route table association public subnet
resource "aws_route_table_association" "Public_RT_Association_1"{
    subnet_id = aws_subnet.Public_Subnet_1.id 
    route_table_id = aws_route_table.Public_RT.id
}

resource "aws_route_table_association" "Public_RT_Association_2"{
    subnet_id = aws_subnet.Public_Subnet_2.id 
    route_table_id = aws_route_table.Public_RT.id
}
