#!/bin/bash -eux

wget -q http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 -O- | apt-key add -
cat > /etc/apt/sources.list.d/lemonldap-ng.list << LDAP
deb http://lemonldap-ng.org/deb squeeze main
LDAP

apt-get update

debconf-set-selections << HANA
nullmailer shared/mailname string hana
nullmailer nullmailer/relayhost string hana.test smtp --auth-login --user=ohana --pass=ohana
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/portal string http://auth.hana.test
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/domain string hana.test
liblemonldap-ng-common-perl liblemonldap-ng-common-perl/ldapBase string dc=hana,dc=test
HANA

apt-get install -qq lemonldap-ng
