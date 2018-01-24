#!/bin/sh
set -e

/usr/local/bin/rubycoinqt_setup.sh

echo "################################################"
echo "# Configuration used: /rubycoin/rubycoin.conf  #"
echo "################################################"
echo ""
cat /rubycoin/rubycoin.conf
echo ""
echo "################################################"

exec rubycoin-qt -datadir=/rubycoin -conf=/rubycoin/rubycoin.conf -printtoconsole "$@"
