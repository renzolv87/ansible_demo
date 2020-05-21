#!/bin/bash

QUARANTINE_DIR=/var/tmp/clamav_quarantine
DATE=`date` 
DATE_SYSLOG=`echo "$DATE" | awk '{print $2" "$3" "$4}'`
DATE_CLAMAVLOG=`echo "$DATE" | awk '{print $1" "$2" "$3" "$4" "$NF}'`


echo "$DATE_SYSLOG $CLAM_VIRUSEVENT_VIRUSNAME -> $CLAM_VIRUSEVENT_FILENAME" >> /var/log/syslog
echo "$DATE_CLAMAVLOG $CLAM_VIRUSEVENT_VIRUSNAME -> $CLAM_VIRUSEVENT_FILENAME" >> /var/log/clamav/infected.log

chmod 400 "$CLAM_VIRUSEVENT_FILENAME" 
mv "$CLAM_VIRUSEVENT_FILENAME" "$QUARANTINE_DIR/"
