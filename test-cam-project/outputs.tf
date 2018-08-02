#####################################################################
##
##      Created 8/2/18 by admin. se-rome for test-cam-project
##
#####################################################################

output = "web_server_ip_address" { 
  value = "${aws_instance.web_server_public_ip"}  
}
output = "db_server_ip_address" { 
  value = "${aws_instance.db_server_public_ip"}  
}
