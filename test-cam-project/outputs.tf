#####################################################################
##
##      Created 8/2/18 by admin. se-rome for test-cam-project
##
#####################################################################

output "db_server_ip_address" { 
  value = "${aws_instance.db_server.public_ip} "   
}
output "web_server_ip_address" { 
  value = "${aws_instance.web_server._public_ip} "   
}
