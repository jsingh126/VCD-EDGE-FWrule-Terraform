terraform {
  required_providers {
    vcd = {
      version = ">= 3.1.0"
      source = "vmware/vcd"
    }
  }
}

#reading csv files with list firewall rules
locals {
  firewall_rules = csvdecode(file("${path.module}/rules.csv"))
}


# variables
variable "vcd_user" {}
variable "vcd_pass" {}
variable "vcd_org" {}
variable "vcd_vdc" {}
variable "vcd_url" {}
variable "vcd_allow_unverified_ssl" {
    default = true
}
variable "vcd_edge" {}

# Configure the VMware vCloud Director Provider
provider "vcd" {
  user                 = var.vcd_user
  password             = var.vcd_pass
  org                  = var.vcd_org
  vdc                  = var.vcd_vdc
  url                  = var.vcd_url
  allow_unverified_ssl = var.vcd_allow_unverified_ssl

}



# Firewall Rules 
resource "vcd_nsxv_firewall_rule" "fw_rules" {
 # org          = "my-org"
  # vdc          = "my-vdc"
for_each = {for frule in local.firewall_rules : frule.sequence => frule}
  edge_gateway = var.vcd_edge
  name = each.value.Name

  source {
    ip_addresses       = each.value.source_addresses != "internal"? [each.value.source_addresses]: null 
    gateway_interfaces = each.value.source_addresses == "internal" ? [each.value.source_addresses] : null 
  }

  destination {
  #ip_addresses = [each.value.destination_addresses]
    ip_addresses       = each.value.destination_addresses != "internal"? [each.value.destination_addresses]: null 
    gateway_interfaces = each.value.destination_addresses == "internal" ? [each.value.destination_addresses] : null 
  }

  service {
    protocol = each.value.protocols
    port = each.value.destination_ports
  }

}

#
