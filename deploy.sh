#!/bin/bash

cd /home/appuser
su - appuser -c "[ -d /home/appuser/reddit ] || /usr/bin/git clone https://github.com/Artemmkin/reddit.git;
                 sudo ln -s /home/appuser/.rvm/rubies/ruby-2.4.1/bin/* /bin/;
                 cd /home/appuser/reddit && sudo bundle install;
                 /home/appuser/.rvm/rubies/ruby-2.4.1/bin/puma -d;
                 #ps aux | grep puma"

/usr/sbin/ufw allow 9292
/usr/sbin/ufw allow ssh
echo 'y' | /usr/sbin/ufw enable
