output "name" {
  value = vsphere_virtual_machine.vm.name
}

output "id" {
  value = vsphere_virtual_machine.vm.id
}

output "ip_address" {
  value = vsphere_virtual_machine.vm.default_ip_address
}
