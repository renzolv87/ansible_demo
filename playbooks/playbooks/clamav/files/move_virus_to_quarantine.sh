#!/bin/bash 

get_info_distro_linux ()
{
#OS=`uname`                                      # Operative System
#DISTRIBUTOR=""                                  # ex: (RedHatEnterpriseServer  - SUSE  )
#DRELEASE_ALL=""                                 # ex: (5.8/4.7/3.1             - 11.3  )
#DRELEASE=""                                     # ex: (5  /4  /3               - 11    )
#DUPDATE=""                                      # ex: (8  /7  /1               - 3     )
#DARCH=""                                        # ex: i386/x86_64/...etc

DARCH=`arch`

if [ -f "/usr/bin/lsb_release" ]; then

	INFO_LSB_RELEASE_A=`/usr/bin/lsb_release -a 2>/dev/null`
	


	DISTRIBUTOR=`echo "$INFO_LSB_RELEASE_A" | awk -F':' '/Distributor ID/ {print $2}' | sed  's/\t//g'`
	DRELEASE_ALL=`echo "$INFO_LSB_RELEASE_A" | awk '/^Release/ {print $2}'`
	DRELEASE=`echo "$INFO_LSB_RELEASE_A" |  grep ^Release | awk '{print $2}' | awk -F"." '{print $1}'`

	# CASOS PARTICULARS:
	case $DISTRIBUTOR in
		SUSE*)
		    DISTRIBUTOR="SuSE"
			#Anadimos INFO_CAT_OSRELEASE porque a partir de SUSE12SP3 en el lsb_release no aparece si es sap o no. Ejemplo: root@VHMANCADDB01-DES:/root# cat /etc/os-release
			if [ -f /etc/os-release ]; then
				INFO_CAT_OSRELEASE=`cat /etc/os-release`
			fi	
		    if [ `echo "$INFO_LSB_RELEASE_A" | grep -i ^Description | grep -c "for SAP"` -gt 0 ]; then
		        DISTRIBUTOR="SuSE_SAP"
		    fi
			#Validamos que exista
			if [ -f /etc/os-release ]; then
				if [ `echo "$INFO_CAT_OSRELEASE" |  grep -c sles_sap` -gt 0 ]; then
					DISTRIBUTOR="SuSE_SAP"
				fi
			fi
			if [ -f /etc/SuSE-release ]; then
				DUPDATE=`cat /etc/SuSE-release | awk -F'=' '/PATCHLEVEL/ {print $2}' | sed 's/ //g'`
			fi
		;;

		RedHat*)
		    DISTRIBUTOR="RedHat"
			## Comportament ESPECIAL per RH3 i RH4
			if [ "$DRELEASE" -eq 4 -o "$DRELEASE" -eq 3 ]; then
				DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Codename | awk '{print $2}' |  tr -dc '[0-9]'`
			else
				DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Release | awk '{print $2}' | awk -F"." '{print $2}'`
			fi
		;;
		OracleServer*|EnterpriseEnterpriseServer)
		    DISTRIBUTOR="Oracle"
		    ## Comportament ESPECIAL per RH3 i RH4
			if [ "$DRELEASE" -eq 4 -o "$DRELEASE" -eq 3 ]; then
				DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Codename | awk '{print $2}' |  tr -dc '[0-9]'`
			else
				DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Release | awk '{print $2}' | awk -F"." '{print $2}'`
			fi
		;;
		Ubuntu)
			DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Release | awk '{print $2}' | awk -F"." '{print $2}'`
		;;
		CentOS)
			DUPDATE=`echo "$INFO_LSB_RELEASE_A" | grep ^Release | awk '{print $2}' | awk -F"." '{print $2}'`
		;;
	esac
else
	INFO_LS_RELEASE=`ls /etc/[r,o,S]*release`
	INFO_ORACLE_AND_RH=`ls /etc/[r,o,S]*release | egrep -i "oracle|redhat" | wc -l`

	if [ "$INFO_ORACLE_AND_RH" -gt 1 ]; then
		INFO_LS_RELEASE="oracle"
	fi
	case $INFO_LS_RELEASE in
		*SuSE*)
			INFO_CAT_RELEASE=`cat /etc/SuSE-release`
            if [ -f /etc/os-release ]; then
                INFO_CAT_OSRELEASE=` cat /etc/os-release`
		        if [ `echo "$INFO_CAT_OSRELEASE" | grep -i ^PRETTY_NAME | grep -c "for SAP"` -gt 0 ]; then
		            DISTRIBUTOR="SuSE_SAP"
		        fi
            fi

			DISTRIBUTOR="SuSE"
			DRELEASE=`echo "$INFO_CAT_RELEASE" | awk -F'=' '/VERSION/ {print $2}' | sed 's/ //g'`
			DUPDATE=`echo "$INFO_CAT_RELEASE" | awk -F'=' '/PATCHLEVEL/ {print $2}' | sed 's/ //g'`
		;;
		*redhat*)
			INFO_CAT_RELEASE=` cat /etc/redhat-release`
			if [ `echo "$INFO_CAT_RELEASE" | grep -wc CentOS` -eq 0 ]; then
				DISTRIBUTOR="RedHat"
			else
				DISTRIBUTOR="CentOS"
			fi
			DRELEASE_ALL=`echo "$INFO_CAT_RELEASE" | sed -e 's/[a-z]*[A-Z]*//g' -e 's/(//g' -e 's/)//g' -e 's/\./ /g' | awk '{print $1"."$2}'`
			DRELEASE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $1}'`
			DUPDATE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $2}'`
		;;
		*oracle*)
			INFO_CAT_RELEASE=` cat /etc/oracle-release`
			DISTRIBUTOR="Oracle"
			DRELEASE_ALL=`echo "$INFO_CAT_RELEASE" | sed -e 's/[a-z]*[A-Z]*//g' -e 's/(//g' -e 's/)//g' -e 's/\./ /g' | awk '{print $1"."$2}'`
			DRELEASE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $1}'`
			DUPDATE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $2}'`
		;;
		*os*)
			INFO_CAT_RELEASE=` cat /etc/os-release`
			DISTRIBUTOR=` cat /etc/os-release | awk -F'=' '/^NAME=/ {print $NF}' | tr -d "\""`
			DRELEASE_ALL=` cat /etc/os-release | awk -F'=' '/VERSION_ID=/ {print $NF}' | tr -d "\""`
			DRELEASE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $1}'`
			DUPDATE=`echo "$DRELEASE_ALL" | awk -F'.' '{print $2}'`
		;;
	esac
fi
}

get_info_distro_linux

case $DISTRIBUTOR in
	CentOS|RedHat)
		OSLOG=/var/log/messages
		;;
	Ubuntu)
		OSLOG=/var/log/syslog
		;;
esac

DATE_SYSLOG=`echo "$DATE" | awk '{print $2" "$3" "$4}'`
CLAMLOG=/var/log/clamav/clamav.log
DATE_CLAMAVLOG=`echo "$DATE" | awk '{print $1" "$2" "$3" "$4" "$NF}'`

FOUNDPATTERN=FOUND 
QUARANTINE_DIR=/var/tmp/clamav_quarantine

NAME_DAY=`date +%a`
MONTH=`date +%b`
DAY=`date +%d`
YEAR=`date +%Y`

files=`grep -w $FOUNDPATTERN $CLAMLOG 2>/dev/null | egrep -w "^$NAME_DAY|$MONTH|$DAY|$YEAR" | awk -F'ScanOnAccess:' '{print $NF}' | awk -F':' '{print $1}' | awk '{print $1}' | sort -u`

if [ ! -z "$files" ]; then
	echo "$files" | while read f
	do
		if [ -e $f ]; then
			echo "$DATE_SYSLOG moving virus: '$f' to quarantine dir: '$QUARANTINE_DIR/'" | tee -a "$OSLOG"
			echo "DATE_CLAMAVLOG moving virus: '$f' to quarantine dir: '$QUARANTINE_DIR/'" | tee -a "$CLAMLOG"
			mv $f "$QUARANTINE_DIR/" 2>/dev/null
		fi
	done
fi
