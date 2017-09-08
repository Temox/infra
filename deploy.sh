#!/bin/bash

set -e

su - appuser -c "[ -d /home/appuser/reddit ] || /usr/bin/git clone https://github.com/Artemmkin/reddit.git;
                 source ~/.rvm/scripts/rvm;
                 cd /home/appuser/reddit && bundle install;
                 puma -d"

/usr/sbin/ufw allow 9292
/usr/sbin/ufw allow ssh
echo 'y' | /usr/sbin/ufw enable
