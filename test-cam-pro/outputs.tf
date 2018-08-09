#####################################################################
##
##      Created 8/9/18 by admin. test cam pro from template designer for test-cam-pro
##
#####################################################################

output "db-server_ip_address" { 
  value = "${aws_instance.db-server.public_ip} "   
}
output "web-server_ip_address" { 
  value = "${aws_instance.web-server._public_ip} "   
}