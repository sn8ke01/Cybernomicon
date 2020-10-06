#!/bin/bash

# Collect certificates and cert related information
# Sources: api.certspotter.com, cert.sh, nmap --script -ssl-cert
# Certifacte Transparency Logs: https://blog.appsecco.com/certificate-transparency-part-3-the-dark-side-9d401809b025

usage(){
       echo -e "[i] Usage: basename $0 [domain]"
       echo -e "[!] Collect cert and cert related information"
}

[[ -z $1 ]] && usage && exit 1

domain=${1}

curl "https://api.certspotter.com/v1/issuances?domain=$domain&include_subdomains=true&expand=dns_names&expand=issuer&expand=cert" >> $domain.certs.json

