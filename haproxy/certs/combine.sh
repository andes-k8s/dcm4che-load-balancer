#!/bin/sh
cat privkey.pem fullchain.pem | tee combined.pem

echo "Agrega en haproxy.cfg"
echo "bind *:443 ssl crt /etc/ssl/private/combined.pem"