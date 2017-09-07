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
