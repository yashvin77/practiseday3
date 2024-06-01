variable "instances" {
  description = "pasiing values to instances keys,tagnames and instance type"
  type = map(object({
    instance_type = string
    key_name = string
 
  }))
  default = {
    "instance1" = {
      instance_type = "t2.micro"
      key_name = "private"
     
    }
    "instance2" = {
      instance_type = "t2.nano"
      key_name = "publicec2key"
     
    }
    "instance3" = {
       instance_type = "t2.large"
       key_name = "newkey"
    
    }
}
}

variable "tag_name" {
  type = list(string)
  default = [ "jen","cad","test"]
}