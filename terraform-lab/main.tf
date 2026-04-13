resource "local_file" "platform_welcome" {
  filename = "${path.module}/welcome.txt"
  content  = "Welcome to Infrastructure as Code. This file was created by Terraform!"
}
