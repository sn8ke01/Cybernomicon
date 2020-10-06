#!/bin/bash

#Sub domain enumeration
#amass enum -d $domain

# CMDS that might be used

### Configurations ###

dnsrecon="/root/tools/dnsrecon/dnsrecon.py"
dictionary="/root/tools/conops/subdomains-top1mil.txt"
subbrute="/root/tools/subbrute/subbrute.py"
reconLog="/root/tools/conops/recon-domain.log"

######################

#d=false
#o=false

about(){
	echo "############  recon-domain.sh ##############
	
This script gathers domain and sub domain names via domain gathering tools

Tools currenlty implemented: amass, subbrute, subfinder

Example Implementations:
amass enum -d domain.com -o domain.com.amass

###########################################
	"
}

usage(){ 
	echo "Usage: conops.sh [-d|-o] [-ha]
	
	OPTIONS
	-d	(required) Domain to scan
	-o 	(required) Output File - plaintext
	-h 	This help
	-a	About this tool
	" 
}

checks(){
	echo "[i] Running req check" 
	hash subfinder 2>/dev/null && echo "[+] Subfinder Installed" || { echo >&2 "[!] Subfinder not installed.  Aborting."; exit 2; }
	hash amass 2>/dev/null && echo "[+] Amass Installed" || { echo >&2 "[!] Amass not installed.  Aborting."; exit 2; }
	hash $subbrute 2>/dev/null && echo "[+] Subbrute available at location: $subbrute" || { echo >&2 "[!] Subbrute not found. Check config in this script.  Aborting."; exit 2; }
	hash $dnsrecon 2>/dev/null && echo "[+] DnsRecon available at location: $subbrute" || { echo >&2 "[!] DnsRecon not found. Check config in this script.  Aborting."; exit 2; }
	echo "[*] All reqs meet"
	
}

logFile(){
	now=$(date +"%Y-%m-%d--%H:%M.%S")
	echo -e "+ [$now] $1"|tee -a $reconLog
}


DNSRecon(){
	echo "[+] Running dnsrecon.py against $domain"
	python3 $dnsrecon -d $domain --dictionary subdomains-top1mil.txt --csv $outfile.csv
}

reconDomains(){
	echo "[i] Check $reconLog for status and errors"

        logFile "Launching Amass."
	amass enum -d $domain -o $outfile.amass || logFile 1> /dev/null #"Amass Failed. Don't know why. Check script cmd."
	logFile  "Amass complete: $outfile.amass"
	
	logFile "Launching next Subfinder"
	subfinder -d $domain -b -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -o $domain.subfinder
	logFile "Subfinder complete: $domain.subfinder"

	logFile "Launching DnsRecon"
	python3 $dnsrecon -d $domain --dictionary $dictionary --csv $outfile.dnsrecon.csv
	logFile "DnsRecon Complete: $outfile.csv"	


}

dclean(){

	echo -e "[i] Removing duplicate domain names"
	echo | awk -v v=$domain -F, '$0 ~ v {print $2 }' $outfile.dnsrecon.csv > $outfile.dnsrecon.domains
	sort -u < $outfile.amass $outfile.subfinder $outfile.dnsrecon.domains > $outfile.total.domains

	n=$(wc -l $outfile.total.domains | awk '{print $1}')
	echo -e "[*] Duplicates removed.  There are $n total domains in $outfile.domains"

}

cert_curl(){
	echo "[+] Getting Cert infor for $domain"
	curl "https://api.certspotter.com/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names&expand=issuer&expand=cert"
}

while getopts "d:o:ha" opt; do
	case ${opt} in
		d ) domain=${OPTARG};;
		o ) outfile=${OPTARG};;
		h ) usage && exit 1;;
		a ) about && exit 1;;
		\? ) echo "Invalid option: ${OPTARG}" 1>&2;;
	esac
done

shift $((OPTIND -1))

if [[ ! "$outfile" ]]
then
	usage
	exit 1
fi


#### MAIN ###

#DNSRecon
#cert_curl
checks
reconDomains
dclean
