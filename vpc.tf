/*-----------VPC , activar ALB también
# Crea la VPC
resource "aws_vpc" "pci_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "pci-vpc"
  }
}

# Subred pública 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.pci_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pci-public-subnet-1"
  }
}

# Subred pública 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.pci_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pci-public-subnet-2"
  }
}

# Crea un Internet Gateway
resource "aws_internet_gateway" "pci_igw" {
  vpc_id = aws_vpc.pci_vpc.id

  tags = {
    Name = "pci-igw"
  }
}