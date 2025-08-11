variable "test_string" {
  description = "Test string variable for the dummy module"
  type        = string
  default     = ""

  validation {
    condition     = length(var.test_string) > 0
    error_message = "\"var.test_string\" cannot be empty."
  }
}