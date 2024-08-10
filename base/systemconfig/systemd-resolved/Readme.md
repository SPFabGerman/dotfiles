systemd-resolved should already be installed.
To use it, make sure to run the following command, so that all applications can make use of it:
```
ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```
