resource "aws_vpc""example" {
    cidr_block = "10.0.0.0/16"
    assign_generated_ipv6_cidr_block = true
    instance_tenancy = "default"


    tags={
        name = "harry"

    }


  
}

resource "aws_subnet""public" {
    vpc_id = aws_vpc.example.id
    cidr_block = "10.0.1.0/24"
    private_dns_hostname_type_on_launch = true
    map_public_ip_on_launch = true
    availability_zone = "us-east-1"
  
}

resource "aws_internet_gateway""igw1" {
    vpc_id = aws_vpc.example.id
    



  
}


resource "aws_route_table""rtpublic" {
vpc_id = aws_vpc.example.id

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
}

}
resource "aws_route_table_association""rtpublicsubnet"{
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rtpublic.id

}

resource "aws_subnet""private" {
    vpc_id = aws_vpc.example.id
    cidr_block = "10.0.2.0/24"
  availability_zone_id = "us-east-1"
  map_public_ip_on_launch = false

}
resource "aws_eip" "nat_eip" {
  vpc = "true"
}

resource "aws_nat_gateway" "default" {
  subnet_id = aws_subnet.public.id
  allocation_id = "aws_eip.nat_eip.id"
}

resource "aws_route_table" "rtprivate" {
 vpc_id = aws_vpc.example.id

 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.default
 }
}
resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private
    route_table_id = aws_route_table.rtprivate
  
}