#!/bin/sh

# Remove the Caddy service script
if [ -f /usr/local/etc/rc.d/caddy ]; then
    echo "Removing file: /usr/local/etc/rc.d/caddy"
    rm -f /usr/local/etc/rc.d/caddy
fi

# Remove the /etc/rc.conf.d/caddy file
if [ -f /etc/rc.conf.d/caddy ]; then
    echo "Removing file: /etc/rc.conf.d/caddy"
    rm -f /etc/rc.conf.d/caddy
fi

echo "Caddy deinstallation completed."

