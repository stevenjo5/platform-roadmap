output "log_content_preview" {
  description = "The data read from the local deploy log"
  value       = data.local_file.existing_log.content
}
