
resource "local_file" "platform_welcome" {
  filename = "${path.module}/${var.file_name}"
  content  = var.file_content
}

