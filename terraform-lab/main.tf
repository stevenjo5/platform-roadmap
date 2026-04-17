
resource "local_file" "platform_welcome" {
  filename = "${path.module}/${var.file_name}"
  content  = var.file_content

  # Day 25: Trigger a local command after creation
  provisioner "local-exec" {
    command = "echo 'DEPLOYMENT SUCCESS: Resource ${self.id} created at $(date)' >> deploy.log"
  }

  # Day 26: The Safety Lock
  lifecycle {
    prevent_destroy = true
  }
}
# Day 27: Data Source to read the existing log file
data "local_file" "existing_log" {
  filename = "${path.module}/deploy.log"
}




