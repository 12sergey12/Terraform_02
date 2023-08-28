resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name       	= var.vpc_name
  zone       	= var.default_zone
  network_id 	= yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name    	= "${ local.org }-${ local.project }-${ local.instance }-web"
  platform_id = var.vm_web_platform
  resources {
	cores     	= var.vm_web_resources["cores"]
	memory    	= var.vm_web_resources["memory"]
	core_fraction = var.vm_web_resources["core_fraction"]
  }
  boot_disk {
	initialize_params {
  	image_id = data.yandex_compute_image.ubuntu.image_id
	}
  }
  scheduling_policy {
	preemptible = true
  }
  network_interface {
	subnet_id = yandex_vpc_subnet.develop.id
	nat   	= true
  }
  metadata = var.auth-ssh
}

data "yandex_compute_image" "ubuntu_2" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "platform_2" {
  name    	= "${ local.org }-${ local.project }-${ local.instance }-db"
  platform_id = var.vm_db_platform_2
  resources {
	cores     	= var.vm_db_resources["cores"]
	memory    	= var.vm_db_resources["memory"]
	core_fraction = var.vm_db_resources["core_fraction"]
  }
  boot_disk {
	initialize_params {
  	image_id = data.yandex_compute_image.ubuntu.image_id
	}
  }
  scheduling_policy {
	preemptible = true
  }
  network_interface {
	subnet_id = yandex_vpc_subnet.develop.id
	nat   	= true
  }
  metadata = var.auth-ssh
}
