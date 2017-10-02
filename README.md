# Infra - Инфраструктурный репозиторий
## DevOps - практика
### Управление облачной инфраструкурой с помощью утилиты **gcloud**

Создание ВМ с применением внешних startup скриптов.
  ./starttup.sh -скрипт описывающий установку mongodb, ruby, bundler и деплой [web-приложения](https://github.com/Artemmkin/reddit.git).

```
gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b reddit-app --metadata-from-file startup-script=/home/temox/infra/startup.sh
```

Добавление firewall-правил.
Устанавливаемое приложение работает на порту tcp:9292. Создаваемое правило позволяет открыть доступ на уровне VPC.
```
gcloud compute firewall-rules create default-puma-server --source-ranges=0.0.0.0/0 --allow=tcp:9292 --target-tags=puma-server
```

### Packer. Сборка образов.
