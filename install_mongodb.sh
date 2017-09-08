#!/bin/bash

/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
/bin/bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

/usr/bin/apt-get update
/usr/bin/apt-get install -y mongodb-org

/bin/systemctl start mongod && /bin/systemctl enable mongod
