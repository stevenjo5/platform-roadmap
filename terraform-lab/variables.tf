variable "file_name" {
  description = "The name of the file created by the platform"
  type        = string
  default     = "welcome.txt"
}

variable "file_content" {
  description = "The text inside the generated file"
  type        = string
  default     = "This infrastructure was provisioned via a dynamic variable!"
}
