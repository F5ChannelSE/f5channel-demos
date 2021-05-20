terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.3.1"
    }
  }
}

provider "bigip" {
    address = "10.1.1.245"
    username = "admin"
    password = "Agility2021!"
}

resource "bigip_command" "showversion" {
  commands   = ["show sys version"]
}

output "showversion" {
    value = "${bigip_command.showversion.command_result}"
}