#!/bin/bash

RED='\033[1;31m'
GRN='\033[1;32m'
YEL='\033[1;33m'
BLU='\033[1;34m'
PUR='\033[1;35m'
NC='\033[0m' # No Color

input="$1"
out="$2"

usage() {
        echo -e "${PUR}[i]${NC} Uses curl to follow redirects and print reponse code"
        echo -e "${RED}[!]${NC} Usage: `basename $0` input-file output-file"
}

status_check() {
        while IFS= read -r line ; do
                read -r response code <<< $(curl --connect-timeout 3 $line -s -L -I -o /dev/null -w '%{url_effective} %{http_code}')
                printf "$line,$response,$code\n" >> $out

                if [[ $code == "200" ]]; then
                        #echo -e "$code == 200"
                        echo -e "${GRN}[+]${NC} $line -->  ${BLU}$response${NC}  ${GRN}$code${NC}"
                else
                        #echo -e "$code == NOT 200"
                        echo -e "${RED}[-]${NC} $line -->  ${YEL}$response${NC}  ${RED}$code${NC}"
                fi



        done < $input
}

[ -z "$1" ] && usage && exit
[ -z "$2" ] && usage && exit

if test -f "$input"
then
        echo -e "Hostname,Redirect(?),response code" > $out
        status_check
else
        echo -e "${RED}[!]${NC} INPUT file does not exist: ${RED}$input${NC}"
fi

exit