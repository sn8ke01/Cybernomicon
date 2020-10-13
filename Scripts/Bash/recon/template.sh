#####################################
# Author: 
# Function:
# Note: 
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
	echo -e "$alert Usage: rolling-profile.sh [OPTION]"
		
	echo -e "OPTIONS
	-h	This Help"
}

########## Functions #################

C:\Users\sn8ke\Box\



########## Script Options ############

while getopts "h" opt; do
	case ${opt} in
		h ) usage ;;
	esac
done

######################################


echo -e "$alert Danger Will Robinson"
echo -e "$info Some information"
echo -e "$other OTHER"
echo -e "$done This task has completed. Enjoy a coke"


