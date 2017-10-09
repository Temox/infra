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
── files
   ├── deploy.sh                 - shell-скрпит деплоя приложения
   └── puma.service              - unit-файл для запуска приложения
```

Создание сервера-приложения, сервера-БД и настройка облачного firewall'а описаны в виде модулей:
```
── modules
   ├── app  - создание сервера приложений
   ├── db   - создание сервера БД
   └── vpc  - настройка VPC
```
Каждый модуль описан тремя файлами:

* *mian.tf*       - создание виртуальной машины, правил облачного файерволла, добавление ssh-ключа для пользователя, добавление внешенго ip-адреса
* *variables.tf*  - описание используемых в модуле переменных
* *outputs.tf*    - описание выводимых переменных после выполнения развертывания. Доступны при выполнении _terraform show_

Создание _prod_ и _stage_ стендов:
```
── terraform
   ├── prod
   └── stage
```
Описание стендов
* *main.tf*       - содержит кастомизированое описание вызова модулей app-сервера, db-сервера и vpc
* *outputs.tf*    - описание выводимых переменных после выполнения развертывания. Доступны при выполнении _terraform show_
* *variables.tf*  - описание используемых переменных для сетнда.


### Ansible. Управление конфигурацией.

Ansible использует конфигурционный файл в соответсвующей дирректории:
```
── ansible
   └── ansible.cfg
```
В данном примере указаны лишь основные параметры:
```
  [defaults]
  hostfile = ./environments/stage/hosts
  remote_user = appuser
  private_key_file = ~/.ssh/appuser
  host_key_checking = False
```

Выполнены различные варианты подготовки серверной инфраструктуры

* Подготовка образов систем packer'ом, с предварительной настройкой:
  _packer_reddit_app.yml_
  _packer_reddit_db.yml_
* Общий _playbook_ для подготовки серверов и выполнения деполя, с использованием тегов:
  _reddit_app_one_play.yml_
* Общий _playbook_ для подготовки серверов и выполнения деполя, с использованием нескольких сценариев:
  _reddit_app_multiple_plays.yml_
* Создание роли:
```
── ansible
    ├── app.yml
    ├── db.yml
    ├── roles

    │   ├── app
    │   └── db
    └── site.yml
 ```
   и использование _packer_ для подготовки образов на основе ролей:
   ```
    ├── packer_app.yml
    ├── packer_db.yml
   ```
Для управления конфигурацией stag и prod стендов используется _environment_, где описано создание каждого из стендов и определены соответвующие переменные, на основе групп хостов:
```
environment
  ├── prod
  │   ├── group_vars
  │   │   ├── all
  │   │   ├── app
  │   │   └── db
  │   └── hosts
  └── stage
      ├── group_vars
      │   ├── all
      │   ├── app
      │   └── db
      └── hosts
```

### Vagrant. Создание локального окружения на основе рецептов.
В данном файле описано создание инфраструктуры, локально, на рабочей машине, с использованием *Vagrant*, для создания ВМ и *Ansible playbooks*, для их настройки:
```
├── ansible
    └── Vagrantfile
```

### Molecule. Testinfra. Тестирование Ansible ролей.
Для тестирования подготовленной роли использовалось ПО _Molecule_. Фреймворк _Testinfra_ ипользуется для выполнения тестов написаных на python.
Описание выполняемых скриптов производится в db/molecule/default/tests/test_default.py

```
── roles
   └── db
       └── molecule
          └── default
              ├── create.yml
              ├── destroy.yml
              ├── INSTALL.rst
              ├── molecule.yml
              ├── playbook.yml
              ├── tests
              │   ├── __pycache__
              │   │   └── test_default.cpython-27-PYTEST.pyc
              │   ├── test_default.py
              │   └── test_default.pyc
              └── ubuntu-xenial-16.04-cloudimg-console.log
```
