#####################################
# Author: Capello, Manuel
# Function: Generate 
# Note: 
######## TODO ########################

# [] incorperate project config
# [] function: sanity
# [] function: roll_profile

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
	echo -e "$alert Must be run from the DIR of the project"

	echo -e "OPTIONS [non are required]
	-h	This Help
	-c 	Sanity Check - Looks for recon output file and returns status
	-x	Generate the rolling profile"
	
	exit 0
}

########### Configs #################

# These hardcoded configs should be temp
# Change to read project.cfg file

project_name="alpha"
project_home=$(awk -v v=$t -F: '$0 ~ v {print $2 }' ${project_name}-project.cfg | tr -d "\n")

########### Funtions ################
sanity(){
	echo -e "$info Sanity Checks"
}


roll_profile(){
	echo -e "$info Building Rolling Profile"

	# WORK

	echo -e "$done Rolling Profile complete.  Check $BLU/web$NC for details"
}



########## Script Options ############

while getopts "chx" opt; do
	case ${opt} in
		h ) usage ;;
		c ) sanity ;; #write sanity check function
		x ) roll_profile ;;
	esac
done

######################################





