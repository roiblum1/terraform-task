output "vm_names" {
  value = [for m in module.vm : m.name]
}

# TODO: output "vm_ips" — a map of VM name -> IP address. Build it from
# module.vm with a `for` expression, but the { for ... } (map) form this
# time, not the [ for ... ] (list) form above. See CHEATSHEET.md.

# TODO: output "inventory_path" — the path the local_file resource actually
# wrote to (one of its own exported attributes).
