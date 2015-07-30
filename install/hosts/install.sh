#!/bin/bash -eux

private=$(ifconfig eth1 | awk '/inet / {print $2}' | cut -d: -f2)

sed 's/\(127\.0\.0\.1\)/'"$private"'/' /etc/lemonldap-ng/for_etc_hosts > \
	/vagrant/install/hosts/hana.hosts
