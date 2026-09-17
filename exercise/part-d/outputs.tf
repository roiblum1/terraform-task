output "vm_names" {
  value = [for m in module.vm : m.name]
}

# TODO: output "vm_ips" -> { for m in module.vm : m.name => m.ip_address }

# TODO: output "inventory_path" -> local_file.ansible_inventory.filename
