variable "dummy_string" {
  description = "String variable for the dummy module"
  type        = string
  default     = ""

  validation {
    condition     = length(var.dummy_string) > 0
    error_message = "\"dummy_string\" cannot be empty."
  }
}