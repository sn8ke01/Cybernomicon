#####################################
# Author: Manny Capello
# Function: Simple wrapper script to streamline a few recon commands
# Note: Nutin facny
######## Implemented Tools ############

# Amass
# WPSCAN

######################################

RED='\033[1;31m' # Warning and Alerts
GRN='\033[1;32m' # Success 
YEL='\033[1;33m' # Doing work
BLU='\033[1;34m' # File or Dir names
PUR='\033[1;35m' # Other
NC='\033[0m' 	 # No Color

alert="$RED[!]$NC"
info="$YEL[i]$NC"
other="$PUR[*]$NC"
done="$GRN[*]$NC"

d="$1"

########### Usage & Help #############

usage(){
	echo -e "$alert Usage: scratchRecon.sh <domain> -aw"
		
	echo -e "OPTIONS (all optional)
	-h	This Help
	-a 	amass scan
	-w	wordpress scan"
}

invalid(){
	echo -e "$alert Invalid Option: ${OPTARG}"
}
########## Functions #################

# Amass #
amass(){
	echo -e "$info ### AMASS ###"
	amass enum -active -d $d -brute -w /usr/share/seclists/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -src -ip -dir amass -config /root/.config/amass/config.ini -o amass_results.txt
	amass enum -d $d -dir amass -brute -ip -src
	amass viz -dir amass -d3
	}

# WPSCAN #
wpscan(){
		echo -e "$info ### WPSCAN ###"
		wpscan --url $d --enumerate ap
	}

########## Script Options ############

while getopts "haw" opt; do
	case ${opt} in
		a ) amass ;;
		w ) wpscan ;;
		h ) usage && exit 1;;
		\? )invalid 1>&2;;		
	esac
done

######################################

exit


