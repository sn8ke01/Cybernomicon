#!/bin/bash

# Gather IP address and Network Blocks

# ARIN Searches
# Looking glass searches - can this be automated?

# echo -e "[!] Gather IP and Network blocks to biuld target list for discovery scans"

ip_file="ip.txt"	# Modify to meet project needs
range_file="ranges.txt"	# Modify to meet project needs


## Resolve IP from domain names
usage(){

       	echo -e "\n[!] You must enter a new-line seperate domain list file"
	echo -e "Usage: $(basename $0) domain_file"
	exit 0
}


domain_file="$1"

[[ -z $domain_file ]] && usage;


while IFS= read -r domain; do
	
	#dig
	ip=$(dig $domain +short|tr "\n" "," |sed -e 's/,$//')
	echo -e "$ip,$domain"
	echo -e "$ip"| sed -e 's/,/\n/' >> $ip_file

	#whois
	range=$(whois $ip |grep NetRange |tr -d " "|cut -d":" -f2)
	echo -e "${range}"
	echo -e "${range}" >> $range_file


done < $domain_file


echo -e "\n"
echo -e "[+] Check ${ip_file} for IP details"
echo -e "[+] Check ${range_file} for network ranges"
echo -e "[!] Chech Whois NetNames before scanning ranges!!"
