# rauc-minimal-setup

The following is not in the script

```bash
sudo wget https://github.com/rauc/rauc/blob/v1.10.1/data/de.pengutronix.rauc.conf -P /usr/share/dbus-1/system.d/de.pengutronix.rauc.conf
```

`./setup` And you'll see traces for a working rauc info and a failing `rauc install`

# Info on your own

```bash
cd rauc/build
./rauc --debug --conf minimal_system.conf info https://github.com/rauc/rauc/raw/a1ca6126a8414553bcc2c3f793e6ffb4faf3bf84/test/good-verity-bundle.raucb
```

# Install on your own
In a terminal 
```bash
cd rauc/build
sudo ./rauc --debug --conf minimal_system.conf service
```
In another 
```bash
cd rauc/build
sudo ./rauc --debug --conf minimal_system.conf install https://github.com/rauc/rauc/raw/a1ca6126a8414553bcc2c3f793e6ffb4faf3bf84/test/good-verity-bundle.raucb
```
This will fail, but all dbus stuff will be triggered.