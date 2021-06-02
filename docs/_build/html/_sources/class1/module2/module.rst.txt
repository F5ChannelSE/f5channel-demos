Demo 2 - Mitigating OWASP Top 10 with AWAF Threat Campaign
==========================================================

#. Confirm BIG-IP is not configured

   - Explore BIG-IP GUI **Local Traffic -> Network Map** to validate tenant_02 app services does not exist

#. Create **main.tf** to use terraform bigip provider

   - Open client server **vscode termninal**
   - ``mkdir ~/projects/lab3``
   - ``cd ~/projects/lab3``
   - ``touch main.tf``
   - use vscode to add the following code to **main.tf**

   .. code:: json

      terraform {
        required_providers {
          bigip = {
            source = "F5Networks/bigip"
          }
        }
      }

      provider "bigip" {
          address = var.address
          username = var.username
          password = var.password
      }

      resource "bigip_as3"  "tenant02_app3" {
         as3_json = "${file("app3.json")}"
      }

#. Create **variables.tf**

   - ``touch variables.tf``
   - use vscode to add the following code to **variables.tf**

   .. code:: json

      variable "address" {}
      variable "username" {}
      variable "password" {}

