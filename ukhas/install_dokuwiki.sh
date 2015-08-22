#!/bin/sh
set -xe
TAR="tar --no-same-permissions --no-same-owner"

mkdir /srv/ukhas-dokuwiki # must not exist already
mkdir /tmp/dokuwiki

wget -qO /tmp/dokuwiki/stable.tgz    http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
$TAR -xf /tmp/dokuwiki/stable.tgz    -C /srv/ukhas-dokuwiki --strip-components=1

wget -qO /tmp/dokuwiki/recaptcha.tgz https://github.com/liip/dw-plugin-recaptcha/archive/master.tar.gz
mkdir /srv/ukhas-dokuwiki/lib/plugins/recaptcha
$TAR -xf /tmp/dokuwiki/recaptcha.tgz -C /srv/ukhas-dokuwiki/lib/plugins/recaptcha --strip-components=1

# wget -qO /tmp/dokuwiki/paypal15.tgz  https://github.com/ukhas/dokuwiki-paypal15/archive/master.tar.gz
# mkdir /srv/ukhas-dokuwiki/lib/plugins/paypal15
# $TAR -xf /tmp/dokuwiki/paypal15.tgz  -C /srv/ukhas-dokuwiki/lib/plugins/paypal15 --strip-components=1

rm -rf /tmp/dokuwiki

rm -rf /srv/ukhas-dokuwiki/data /srv/ukhas-dokuwiki/install.php
ln -s /srv/ukhas-data/users.auth.php /srv/ukhas-dokuwiki/conf
ln -s /srv/ukhas-data/data           /srv/ukhas-dokuwiki/
