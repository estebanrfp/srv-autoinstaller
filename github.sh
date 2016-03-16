#!/bin/bash

# Github

ssh-keygen -q -b 4096 -t rsa -N "" -f ~/.ssh/id_rsa
KEY_TOKEN="$1"
TITLE= $hostname
PUBKEY=`cat ~/.ssh/id_rsa.pub`

RESPONSE=`curl -s -H "Authorization: token ${KEY_TOKEN}" \
  -X POST --data-binary "{\"title\":\"${TITLE}\",\"key\":\"${PUBKEY}\"}" \
  https://api.github.com/user/keys`

KEYID=`echo $RESPONSE \
  | grep -o '\"id.*' \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`

echo "Public key deployed to remote service."

# do some work here

# sleep 10

#curl -s -H "Authorization: token ${KEY_TOKEN}" -X DELETE \
#   https://api.github.com/user/keys/${KEYID} \
#  -o /dev/null

#echo "Public key removed from remote service."

#rm -rf ./script.key*