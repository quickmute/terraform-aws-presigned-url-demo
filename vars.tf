variable "myip" {
  description = "This is your IP address or range of IP you want to test this from."
}

variable "bucketname" {
  description = "This is the name of your bucket you want to create"
}

variable "api_name" {
  default     = "exampleAPI"
  description = "Name of your Gateway API resource"
}

variable "api_resource_path" {
  default     = "example"
  description = "Resource Path"
}

variable "lambda_name" {
  default     = "example"
  description = "Name of your Gateway API resource"
}

