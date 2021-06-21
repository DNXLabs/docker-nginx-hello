#!/bin/bash

set -ex

echo ">> GENERATING SSL CERT ..."

PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

cd /opt/ssl/
openssl genrsa -des3 -passout pass:${PASS} -out server.pass.key 2048
openssl rsa -passin pass:${PASS} -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj "/C=AU/ST=NSW/L=Australia/O=dnx.solutions/OU=dnx.solutions/CN=hello.dnx.solutions"
openssl x509 -req -sha256 -days 3650 -in server.csr -signkey server.key -out server.crt
cd -

echo ">> ... DONE"