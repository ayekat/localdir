VLS - Virtual Local Server
==========================

This provides scripts and systemd service files to easily create and configure
VDE switches and launch a qemu instance in the background that is hooked up to
the said VDE switch.


build and install
-----------------

``make`` and ``make install`` should build and install all files necessary for
VLS.

By default the scripts will be installed in ``/usr/local/bin``. In order to
change the path, modify the ``INSTALLDIR`` value in the Makefile. You will need
to rerun ``make`` before installing (otherwise things may break horribly).


vde
---

The ``vde`` script will create a VDE switch according to ``/etc/conf.d/vde``. If
the file does not exist, a default configuration will be used (most likely not
what you want). The tap interface that is connected to the switch will be
configured with the first IP address found in ``/etc/dnsmasq.conf``.

The VDE is brought up and configured with

	vde start

and down with

	vde stop

In order to automate this process at boot, you may enable the according systemd
service file:

	systemctl enable vls.service

The other systemctl commands (``start``, ``stop``) also work, of course.


vls
---

**NOTE**: Currently ``vls`` uses a hardcoded command line to launch the VM.
This will be fixed soon (probably by adding a config file).

The ``vls`` script will launch a qemu virtual machine in the background, and
hook it up to the abovementioned VDE switch.

The VLS is brought up with

	vls start

and down with

	vls stop

In order to automate this process at boot, you may enable the according systemd
service file:

	systemctl enable vls.service

The other systemctl commands (``start``, ``stop``) also work, of course.
