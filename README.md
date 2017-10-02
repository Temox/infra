# Infra - Инфраструктурный репозиторий
## DevOps - практика
### Управление облачной инфраструкурой с помощью утилиты **gcloud**

Создание ВМ с применением внешних startup скриптов.
  ./startup.sh -скрипт описывающий установку mongodb, ruby, bundler и деплой [web-приложения](https://github.com/Artemmkin/reddit.git).

```
gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b reddit-app --metadata-from-file startup-script=/home/temox/infra/startup.sh
```

Добавление firewall-правил.
Устанавливаемое приложение работает на порту tcp:9292. Создаваемое правило позволяет открыть доступ на уровне VPC.
```
gcloud compute firewall-rules create default-puma-server --source-ranges=0.0.0.0/0 --allow=tcp:9292 --target-tags=puma-server
```

### Packer. Сборка образов.
*Packer* - ПО позволяющее создавать кастомизированые образы ОС на основе имеющихся дефолтных, предоставляемых провайдерами облачных систем.

_infra/packer/by_scripts/ubuntu16.json_ - шаблон для создания ВМ в облаке GCP.

В данном примере используется _builder_ _goolecompute_ для работы с API GCP.

Для кастомизации образа, установки необходимого ПО и копирования приложения, используются _provisioners_, для запуска .sh скриптов, _shell_. 

В качестве .sh скриптов используются файлы:
```
    infra/packer/scripts/
                 ├── install_mongodb.sh - устанвка _MongoDb_
                 └── install_ruby.sh    - установка _Ruby_ и _Bundler_
```

В качестве переменных _variables_ указываеются параметры определяющие проект в GCP _project_id_, дефолтный образ _source_image_ и тип создаваемого инстанса _machine_type_.

Результатом запуска _packer_ с данным шаблоном, является ВМ подготовленная к диплою приложения Ruby-приложения:
```
packer build -var 'project_id=*ID-проекта_в_облаке*' -var 'source_image=*Имя_образа*' packer/by_scripts/ubuntu16.json
```

### Terraform. Основы IaC.
*Terraform* - ПО позволяющее описать требуемуе состояние инфраструктуры, с момента создания виртуального сервера и добавления правил firewall, до деплоя самого приложения.

*./terraform* - описание создания prod и stage инфрастуктуры. Включает в себя создание серверов БД и серверов приложений.

```
terraform/
├── files
│   ├── deploy.sh                 - shell-скрпит деплоя приложения
│   └── puma.service              - unit-файл для запуска приложения
```

Создание сервера-приложения, сервера-БД и настройка облачного firewall'а описаны в виде модулей
```
── modules
   ├── app
   ├── db
   └── vpc
```

```
── prod
   ├── main.tf
   ├── outputs.tf
   ├── outputs.tf_
   └── variables.tf
```
```
── stage
   ├── main.tf
   ├── outputs.tf
   ├── outputs.tf_
   └── variables.tf
```
