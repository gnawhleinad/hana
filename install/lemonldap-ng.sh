#!/bin/bash -eux

wget -q http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 -O- | apt-key add -
cat > /etc/apt/sources.list.d/lemonldap-ng.list << OHANA
deb http://lemonldap-ng.org/deb squeeze main
OHANA

apt-get update

debconf-set-selections << OHANA
nullmailer shared/mailname string hana
nullmailer nullmailer/relayhost string hana.test smtp --auth-login --user=hana --pass=hana
OHANA

apt-get install -qq apache2 libapache2-mod-perl2 libapache-session-perl \
	libnet-ldap-perl libcache-cache-perl libdbi-perl perl-modules \
	libwww-perl libcache-cache-perl libxml-simple-perl  libsoap-lite-perl \
	libhtml-template-perl libregexp-assemble-perl libjs-jquery \
	libxml-libxml-perl libcrypt-rijndael-perl libio-string-perl \
	libxml-libxslt-perl libconfig-inifiles-perl libjson-perl \
	libstring-random-perl libemail-date-format-perl libmime-lite-perl \
	libcrypt-openssl-rsa-perl libdigest-hmac-perl libclone-perl \
	libauthen-sasl-perl libnet-cidr-lite-perl libcrypt-openssl-x509-perl \
	libauthcas-perl libtest-pod-perl libtest-mockobject-perl \
	libauthen-captcha-perl libnet-openid-consumer-perl \
	libnet-openid-server-perl libunicode-string-perl libconvert-pem-perl \
	libmouse-perl

debconf-set-selections << OHANA
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/portal string http://auth.hana.test
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/domain string hana.test
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/ldapBase string dc=hana,dc=test
OHANA

apt-get install -qq lemonldap-ng

sed -i 's/example\.com/hana.test/g' \
	/etc/lemonldap-ng/* \
	/var/lib/lemonldap-ng/conf/lmConf-1 \
	/var/lib/lemonldap-ng/test/index.pl

a2ensite handler-apache2.conf
a2ensite portal-apache2.conf
a2ensite manager-apache2.conf
a2ensite test-apache2.conf

a2enmod perl

sed -i '/useLocalConf =/s/;//' /etc/lemonldap-ng/lemonldap-ng.ini
sed -i 's/;\(trustedDomains = \).*/\1*/' /etc/lemonldap-ng/lemonldap-ng.ini
sed -i 's/\(protection = \).*/\1none/' /etc/lemonldap-ng/lemonldap-ng.ini

sed -i '/cgi-script/s/^#*/#/' /etc/lemonldap-ng/manager-apache2.conf
sed -i '/perl-script/s/#//' /etc/lemonldap-ng/manager-apache2.conf
sed -i '/PerlResponse/s/#//' /etc/lemonldap-ng/manager-apache2.conf

apache2ctl configtest
apache2ctl restart

cat /etc/lemonldap-ng/for_etc_hosts >> /etc/hosts
