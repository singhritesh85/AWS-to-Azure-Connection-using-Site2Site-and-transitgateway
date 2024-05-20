module "azure_vm" {
  source = "../azure-module" 
  prefix = var.prefix 
  location = var.location
  vm_size = var.vm_size[0]
  availability_zone = var.availability_zone
  static_dynamic = var.static_dynamic
  disk_size_gb = var.disk_size_gb
  extra_disk_size_gb = var.extra_disk_size_gb
  env = var.env[0]
  computer_name = var.computer_name
  admin_username = var.admin_username
  admin_password = var.admin_password
}

