#####################################
# Author: Manny Capello
# Function: Simple wrapper script to streamline a few recon commands
# Note: Nutin facny
######## TODO ########################

# [] Todo items

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

########### Usage & Help #############

usage(){
	echo -e "$alert Usage: scratchRecon.sh <domain>"
		
	echo -e "OPTIONS
	-h	This Help"
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

testOne(){
	echo "Test One"
	}
	
testTwo(){
	echo "Test Two"
	}

########## Script Options ############

while getopts "htr" opt; do
	case ${opt} in
		a ) amass ;;
		w ) wpscan ;;
		t ) testOne ;;
		r ) testTwo ;;
		h ) usage && exit 1;;
		
	esac
done

######################################




echo -e "$alert Danger Will Robinson"
echo -e "$info Some information"
echo -e "$other OTHER"
echo -e "$done This task has completed. Enjoy a coke"


