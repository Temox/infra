#!/bin/bash

FOLDER=/home/appuser
if [ -d $FOLDER ]; then
  true
else
  mkdir $FOLDER
fi

echo "home dir has founded"
cd "$FOLDER"
echo $(pwd)
su - appuser -s '/bin/bash' -c "/usr/bin/gpg --keyserver 'hkp://keys.gnupg.net' --recv-keys '409B6B1796C275462A1703113804BB82D39DC0E3';
/usr/bin/curl -sSL https://get.rvm.io | /bin/bash -s stable;
source $FOLDER/.rvm/scripts/rvm;
$FOLDER/.rvm/bin/rvm requirements;
$FOLDER/.rvm/bin/rvm install 2.4.1;
sudo ln -s /home/appuser/.rvm/rubies/ruby-2.4.1/bin/* /bin/;
sudo gem install bundler -V --no-ri --no-rdoc;
ruby -v
$FOLDER/.rvm/rubies/ruby-2.4.1/bin/gem -v bundler"


/usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
/bin/bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

/usr/bin/apt-get update
/usr/bin/apt-get install -y mongodb-org

/bin/systemctl start mongod && /bin/systemctl enable mongod
#/bin/systemctl status mongod | grep 'Active:'

cd /home/appuser
su - appuser -c "[ -d /home/appuser/reddit ] || /usr/bin/git clone https://github.com/Artemmkin/reddit.git;
                 sudo ln -s /home/appuser/.rvm/rubies/ruby-2.4.1/bin/* /bin/;
                 cd /home/appuser/reddit && sudo bundle install;
                 /home/appuser/.rvm/rubies/ruby-2.4.1/bin/puma -d"

/usr/sbin/ufw allow 9292
/usr/sbin/ufw allow ssh
echo 'y' | /usr/sbin/ufw enable
