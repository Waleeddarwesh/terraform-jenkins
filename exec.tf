# #remote_exec
# resource "app_ec2_az2" "remote_exec" {
#   provisioner "remote-exec" {
#     inline = [
#       "echo Hello, World!"
#     ]
#   }

#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ec2-user"
#     private_key = file("R:\\terraform\\secondproject\\terraform-key.pem")
#   }
# }