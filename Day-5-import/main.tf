resource "aws_instance" "myvm" {
 ami           = "unknown"#(we need to add from state file reference)
 instance_type = "unknown"#(we need to add from state file reference)
 #rest all attributes need to be added to match actual resource preseence in AWS 
}


# Command 
#terraform import aws_instance.myvm  <instance id> 

#Note : Here instance id is manually created own in by logging in AWS 