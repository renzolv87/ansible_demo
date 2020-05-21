#!/bin/bash 

CLAMLOG=/var/log/clamav/clamav.log
FOUNDPATTERN=FOUND 
QUARANTINE_DIR=/var/tmp/clamav_quarantine

NAME_DAY=`date +%a`
MONTH=`date +%b`
DAY=`date +%d`
YEAR=`date +%Y`

files=`grep -w $FOUNDPATTERN $CLAMLOG 2>/dev/null | egrep -w "^$NAME_DAY|$MONTH|$DAY|$YEAR" | awk -F'ScanOnAccess:' '{print $NF}' | awk -F':' '{print $1}' | awk '{print $1}' | sort -u | tr "\n" " "`

if [ ! -z "$files" ]; then
	mv $files "$QUARANTINE_DIR/" 2>/dev/null
fi
