### Домашнее задание к занятию «Основы Terraform. Yandex Cloud» Баранов Сергей

### Цели задания

1. Создать свои ресурсы в облаке Yandex Cloud с помощью Terraform.
2. Освоить работу с переменными Terraform.


### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Исходный код для выполнения задания расположен в директории [**02/src**](https://github.com/netology-code/ter-homeworks/tree/main/02/src).


### Задание 0

1. Ознакомьтесь с [документацией к security-groups в Yandex Cloud](https://cloud.yandex.ru/docs/vpc/concepts/security-groups?from=int-console-help-center-or-nav).
2. Запросите preview-доступ к этому функционалу в личном кабинете Yandex Cloud. Обычно его выдают в течение 24-х часов.
https://console.cloud.yandex.ru/folders/<ваш cloud_id>/vpc/security-groups.   
Этот функционал понадобится к следующей лекции. 


### Задание 1
В качестве ответа всегда полностью прикладывайте ваш terraform-код в git.

1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
2. Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. **Вы можете выбрать иной способ безопасно передать секретные данные в terraform.**
3. Сгенерируйте или используйте свой текущий ssh-ключ. Запишите его открытую часть в переменную **vms_ssh_root_key**.
4. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.

Platform "standart-v4" not found

with yandex_compute_instance.platform, on main.tf line 15, in resource "yandex_compute_instance" "platform": 15: resource "yandex_compute_instance" "platform" {

Исправил на standard-v1, после чего появилась ошибка: error: code = InvalidArgument desc = the specified number of cores is not available on platform "standard-v1"; allowed core number: 2, 4

Указал 2 ядра и terraform apply прошел.

5. Ответьте, как в процессе обучения могут пригодиться параметры

 ```preemptible = true``` и ```core_fraction=5``` в параметрах ВМ. Ответ в документации Yandex Cloud.


preemptible = true устанавливается чтобы создать прерываемую ВМ. Она дешевле, хотя и имеет ряд ограничений: может быть остановлена в любой момент, может не запуститься (если в зоне доступности не хватает ресурсов), для неё не действует SLA.

- core_fraction=5 - уровень производительности 5%. Он гарантирует максимальное выделение ресурсов согласно выбранной платформы в течение данной части времени. То есть в этом конкретном случае 5% процессорного времени ВМ может работать на максимальной частоте, предоставляемой выбранной платформой intel broadwell. Этот параметр тоже очень полезен в период обучения, так как в этом случае нет никакой необходимости платить лишние деньги за гарантированный уровень производительности 100%.

В качестве решения приложите:

- скриншот ЛК Yandex Cloud с созданной ВМ;

![monitoring](https://github.com/12sergey12/Terraform_02/blob/main/images/7.2_1.png)

![monitoring](https://github.com/12sergey12/Terraform_02/blob/main/images/7.2_1.1.png)

- скриншот успешного подключения к консоли ВМ через ssh. К OS ubuntu необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address";

![monitoring](https://github.com/12sergey12/Terraform_02/blob/main/images/7.2_2.png)

- ответы на вопросы.


---


### Задание 2

1. Изучите файлы проекта.
2. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на **отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: **vm_web_name**.
2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** прежними значениями из main.tf. 
3. Проверьте terraform plan. Изменений быть не должно. 

```
 data "yandex_compute_image" "ubuntu" {
   family = var.vm_web_family
   }
   resource "yandex_compute_instance" "platform" {
     name        = var.vm_web_instance_name
     platform_id = "standard-v1"
     resources {
     cores         = 1
     memory        = 1
     core_fraction = 5 
     }
     ...
```


```
root@baranovsa:/home/baranovsa/ter-homeworks/02/src# terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu_2: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enp8ch7kjm705edop4h5]
data.yandex_compute_image.ubuntu: Read complete after 3s [id=fd8pqclrbi85ektgehlf]
data.yandex_compute_image.ubuntu_2: Read complete after 3s [id=fd8pqclrbi85ektgehlf]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bt18si9f18erjn2hta]
yandex_compute_instance.platform_2: Refreshing state... [id=fhm0clji095dag576md0]
yandex_compute_instance.platform: Refreshing state... [id=fhml2jkvh81fnqvekq1l]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no
differences, so no changes are needed.
root@baranovsa:/home/baranovsa/ter-homeworks/02/src#
```


### Задание 3

1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: **"netology-develop-platform-db"** ,  cores  = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом **vm_db_** в том же файле ('vms_platform.tf').
3. Примените изменения.

```
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex"
}
variable "vm_web_instance_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "platform"
}
variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex"
}
variable "vm_db_instance_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "platform_2"
}
```


### Задание 4

1. Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.
2. Примените изменения.

![monitoring](https://github.com/12sergey12/Terraform_02/blob/main/images/7.2_4.png)

В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Задание 5

1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.
3. Примените изменения.

```
locals {
  org      = "netology"
  project  = "develop"
  instance = "platform"
}
```

Указал имёна ВМ при помощи local переменных

```
name = "${ local.org }-${ local.project }-${ local.instance }-web"

name = "${ local.org }-${ local.project }-${ local.instance }-db"
```

Пересоздал инфраструктуру. Имена инстансов на месте.


### Задание 6

1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, объедините их в переменные типа **map** с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную **vms_resources** и уже внутри неё конфиги обеих ВМ — вложенный map.
2. Также поступите с блоком **metadata {serial-port-enable, ssh-keys}**, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan. Изменений быть не должно.


Переменные типа map:

```
 variable vm_db_resources {
   type = map
   default = {
     cores = 2
     memory = 4
     core_fraction = 20
   }
 }
variable vm_web_resources {
  type = map
  default = {
    cores = 2
    memory = 4
    core_fraction = 100
   }
 }
```

Новый вид блока resources (на примере vm_db_):

```
 resources {
   cores         = var.vm_db_resources["cores"]
   memory        = var.vm_db_resources["memory"]
   core_fraction = var.vm_db_resources["core_fraction"]
 }
```
В variables.tf прямо указал данные для авторизации на ВМ по ssh:

```
variable auth-ssh {
  type = map
  default = {
   serial-port-enable = 1
   ssh-keys = "ubuntu:ssh-ed25519 AAAAC3Nz.......................................SrgCM root@baranovsa"
  }
}
```

А в main.tf сослался на переменную metadata = var.auth-ssh
