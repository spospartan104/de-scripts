#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IPSite="whatismyip.cc"
TMPFILE="$DIR/tempwimp"
wget -O $TMPFILE -o /dev/null $IPSite
if [ ! -f $TMPFile ]; then
  echo "NO.IP.RET.URN" 
  #> ip.address
else
  cat $TMPFILE | grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" 
  #> ip.address
fi
rm $TMPFILE 
