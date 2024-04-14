variable "aws" {
  type = object({
    region = string
    availability_zones = list(string)
  })
}

variable "project_name" {
  type = string
  default = "Minecraft Server"
}
