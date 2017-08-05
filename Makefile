
LIBDIR=/usr/lib/thinkpad-fan-control-script
SYSTEMDDIR=/lib/systemd/system


install:
	mkdir -p $(LIBDIR)
	chmod 0755 thinkpad-fan-control-script.sh
	cp thinkpad-fan-control-script.sh $(LIBDIR)
	chmod 0644 thinkpad-fan-control-script.service
	cp thinkpad-fan-control-script.service $(SYSTEMDDIR)


start:
	systemctl enable thinkpad-fan-control-script
	systemctl start thinkpad-fan-control-script

stop:
	systemctl stop thinkpad-fan-control-script
	systemctl disable thinkpad-fan-control-script


