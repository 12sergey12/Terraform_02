###vm1
variable "vm_web_family" {
  type    	= string
  default 	= "ubuntu-2004-lts"
  description = "yandex"
}
variable "vm_web_platform" {
  type    	= string
  default 	= "standard-v1"
  description = "platform"
}

###vm2
variable "vm_db_family" {
  type    	= string
  default 	= "ubuntu-2004-lts"
  description = "yandex"
}
variable "vm_db_platform_2" {
  type    	= string
  default 	= "standard-v1"
  description = "platform_2"
}
variable "vm_web_resources" {
   type = map
   default = {
  	"cores"     	= "2"
  	"memory"    	= "1"
  	"core_fraction" = "5"
 }
}
variable "vm_db_resources" {
   type = map
   default = {
  	"cores"     	= "2"
  	"memory"    	= "2"
  	"core_fraction" = "20"
 }
}
variable auth-ssh {
  type = map
  default = {
   serial-port-enable = 1
   ssh-keys = "ubuntu:ssh-ed25519 A............M root@baranovsa"
  }
}
