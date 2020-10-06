#!/bin/bash

# Simple system discovery script

# Project Root from project.cfg file

usage(){
	echo -e "[!] The script requires an input file created by recon-ip.sh."
	echo -e "[!] The input file should be located in /project_root/ip/rolling-ips.txt"
	exit 0
}

j=$(date +%j)
target_file="$project_root/targets/rolling-ip.txt"	# Reads in from the complete IP file
out="$project_root/daily-scans/disco-daily_${j}"
echo $targets

[[ -z ${target_file} ]]; usage;

nmap -vv -R --reason -sn --max-rate 150 -PS22-25,80,139,161,162,443,445,1433,3389,8443,8080 -PA22-25,80,139,161,162,443,445,1433,3389,8443,8080 $targets -oA ${out}
