variable "mumai_ami" {
    type = string
    default = ""
}

variable "Us_ami" {
    type = string
    default = ""
}

variable "instance_type" {

    type = string
    default = ""  
}
variable "key_name" {
  type = string
  default = ""
}

variable "yashu" {
  type = list(string)
  default = [ "Project_1","Project_2","Project_3" ]
}