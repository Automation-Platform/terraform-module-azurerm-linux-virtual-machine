variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "size" {
  type = string
}

variable "os_disk_size_gb" {
  type = number
  validation {
    condition     = var.os_disk_size_gb >= 30
    error_message = "OS Disk size must be at least 30GB."
  }
  validation {
    condition     = var.os_disk_size_gb <= 512
    error_message = "OS Disk size must be less than 512GB"
  }
}

variable "os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "subnet_id" {
  type = string
}


variable "data_disks" {
  type = list(object({
    name : string
    size_gb : number
    storage_account_type : optional(string, "Standard_LRS")
  }))
  default = []
}

variable "source_image" {
  type = map(string)
}

variable "admin_password" {
  type    = string
  default = null
}

variable "public_ip_enabled" {
  type    = bool
  default = false
}

variable "admin_username" {
  type    = string
  default = "azadmin"
}

variable "vm_tags" {
  type    = map(string)
  default = {}
}

variable "admin_ssh_key" {
  type    = string
  default = null
}

variable "boot_diagnostic_storage_account_uri" {
  type    = string
  default = null
}
