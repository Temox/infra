# infra
## Infrastructure repository
devops homeworks

Create VM and apply startup script
```
gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b reddit-app --metadata-from-file startup-script=/home/temox/infra/startup.sh
```

Add firewall rule
```
gcloud compute firewall-rules create default-puma-server --source-ranges=0.0.0.0/0 --allow=tcp:9292 --target-tags=puma-server
```
