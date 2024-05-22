variable "ami" {
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
  default = [ "dev","var" ]
}