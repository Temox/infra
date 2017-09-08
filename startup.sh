#!/bin/bash

#install ruby
set -e

su - appuser -c "/usr/bin/gpg --keyserver 'hkp://keys.gnupg.net' --recv-keys '409B6B1796C275462A1703113804BB82D39DC0E3';
                 /usr/bin/curl -sSL https://get.rvm.io | /bin/bash -s stable;
                 source ~/.rvm/scripts/rvm;
                 rvm requirements;
                 rvm install 2.4.1;
                 gem install bundler -V --no-ri --no-rdoc;
                 ruby -v
                 gem -v bundler"

#install MongoDB
/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
/bin/bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

/usr/bin/apt-get update
/usr/bin/apt-get install -y mongodb-org

/bin/systemctl start mongod && /bin/systemctl enable mongod


#deploy app
su - appuser -c "[ -d /home/appuser/reddit ] || /usr/bin/git clone https://github.com/Artemmkin/reddit.git;
                 source ~/.rvm/scripts/rvm;
                 cd /home/appuser/reddit && bundle install;
                 puma -d"

/usr/sbin/ufw allow 9292
/usr/sbin/ufw allow ssh
echo 'y' | /usr/sbin/ufw enable
