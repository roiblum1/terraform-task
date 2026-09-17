# TODO: this module needs to expose three things to whoever calls it:
#   - "name"       the VM's name
#   - "id"         the VM's ID
#   - "ip_address" the VM's IP address (as reported by VMware Tools)
#
# Check the vsphere_virtual_machine resource's exported attributes (provider
# docs, or `terraform state show` on a real one) to find the right attribute
# names to point each output at.
#
# These three are the module's entire interface to the outside world — the
# root module can only see what you output here.
