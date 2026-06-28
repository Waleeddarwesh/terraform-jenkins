locals {

  public_subnets = {

    public-az1 = {
      cidr = "10.0.1.0/24"
      az   = "us-east-1a"
    }

    public-az2 = {
      cidr = "10.0.3.0/24"
      az   = "us-east-1b"
    }

  }

  private_subnets = {

    private-az1 = {
      cidr = "10.0.2.0/24"
      az   = "us-east-1a"
    }

    private-az2 = {
      cidr = "10.0.4.0/24"
      az   = "us-east-1b"
    }

  }

}