output "vm_names" {
  value = [for m in module.vm : m.name]
}
