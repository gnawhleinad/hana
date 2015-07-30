.PHONY: all
all: /etc/hosts

/etc/hosts: install/hosts/hana.hosts
	@option=$$(uname | grep -q Darwin && echo "''" || echo "")
	@sed -i "$$option" 's/^.*hana//' $@
	cat $< >> $@
