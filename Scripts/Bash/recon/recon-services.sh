#!/bin/bash

# Read in Root from project.cfg and update below variables

J=$(date +%j) #julain date
INPUT_FILE=$(echo "/root/botw-ext/daily-scans/disco-daily_${J}.gnmap")
OUTPUT_FILE="/root/botw-ext/daily-scans/port-daily_${J}"
TARGET_FILE="/root/botw-ext/daily-scans/target-list.lst"

##########################

# Get daily systms that are up and create a target list
echo '' > ${TARGET_FILE}
awk '/Up/ {print $2}' ${INPUT_FILE} |sort -u  > ${TARGET_FILE}

# Add discovered hostnames to target list


#Port scan systems
nmap -vv -Pn -sTV --open --reason --top-ports 1000 --script ssl-cert --max-rate 175 -iL $TARGET_FILE --randomize-hosts -oA $OUTPUT_FILE
