#!/usr/bin/env bash
# https://github.com/cofyc/dnscrypt-wrapper
expiry=21
name=2.dnscrypt-cert.$(tr -dc '[:alnum:]' < /dev/urandom | fold \
-w20 | head -n1)
rm -f 0.crt 0.key public.key secret.key
pkill -9 dnscrypt-wrapper
dnscrypt-wrapper --gen-provider-keypair --provider-name=$name \
  --ext-address=$(curl -s https://icanhazip.com/) 2>/dev/null |\
   grep sdns
dnscrypt-wrapper --gen-crypt-keypair --crypt-secretkey-file=0.key >\
/dev/null
dnscrypt-wrapper --gen-cert-file \
  --crypt-secretkey-file=0.key --provider-cert-file=0.crt \
  --provider-publickey-file=public.key \
  --provider-secretkey-file=secret.key --cert-file-expire\
  -days=$expiry >/dev/null
dnscrypt-wrapper --no-tcp --resolver-address=127.0.0.1:53 \
  --listen-address=0.0.0.0:443 --provider-name=$name \
  --crypt-secretkey-file=0.key --provider-cert-file=0.crt -V
