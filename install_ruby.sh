#!/bin/bash
set -e

su - appuser -c "/usr/bin/gpg --keyserver 'hkp://keys.gnupg.net' --recv-keys '409B6B1796C275462A1703113804BB82D39DC0E3';
                 /usr/bin/curl -sSL https://get.rvm.io | /bin/bash -s stable;
                 source ~/.rvm/scripts/rvm;
                 rvm requirements;
                 rvm install 2.4.1;
                 gem install bundler -V --no-ri --no-rdoc;
                 ruby -v
                 gem -v bundler"
