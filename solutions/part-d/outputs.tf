output "vm_names" {
  value = [for m in module.vm : m.name]
}

output "vm_ips" {
  value = { for m in module.vm : m.name => m.ip_address }
}

output "inventory_path" {
  value = local_file.ansible_inventory.filename
}
