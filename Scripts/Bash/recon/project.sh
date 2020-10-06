 #!/bin/bash

# Tools are run with specific flags to get specific results and then this tools works wit those results. 
# This tools currently (and probabyl never will) offer the ability to run the recon tools with other options.

## TODO
# Create .cfg file in project home dir


RED='\033[1;31m' # Warrning and Alerts
GRN='\033[1;32m' # Success 
YEL='\033[1;33m' # Doing work
BLU='\033[1;34m' # File or Dir names
PUR='\033[1;35m' # Other
NC='\033[0m' 	 # No Color

########### Configurations #############

home="FALSE"
project_root="/projects"
project_home="/projects/${home}/" 	# DO NOT MODIFY: initalize project root directory
pentest_grp="cyber1337"			# Modiy to existsing group name to be used for project managment
project_dir_tree=(domain ip daily_scans cert html)
dscan_tree=(host_enum service_enum nmap_vulns)

########################################

### Checks ###

# Projects Dir
check_project_root(){
if [[ -d "${project_root}" ]] 
then
       	echo -e "[+] ${project_root} already exists. Moving on..."
else
	echo -e "${RED}[!]${NC} No Project Root folder"
	echo -e "${YEL}[+]${NC} Creating ${BLU}${project_root}${NC}"
	mkdir /${project_root}
	echo -e "${YEL}[+]${NC} Giving group ownership to ${PUR}${pentest_grp}${NC}"
	chgrp ${pentest_grp} ${project_root}
fi
}

# Project ROOT directory /project/$home
check_project_home(){
	if [[ ${home} = "FALSE" ]]
	then
		echo -e "[!] New Project? [y/n]"
		read a

		if [[ $a = "Y" ]] || [[ $a = "y" ]]
		then
			echo -e "[?] Name project:"
			echo -e "[i] Naming Convention ${PUR}botw-q#-year${NC}"
			read -r home

			if [[ -d "${project_root}/${home}" ]]
			then
				echo -e "[!] Project already exists.  Exiting ..."
				exit 1
			else
				echo -e "[+] Creating ${home}"
				create_project $home
			fi
		
		elif [[ $a = "n" ]] || [[ $a = "N" ]]
		then
			echo -e "[!] Nothing else to do.  Exiting ..."
			exit 0
		else
			echo -e "Not a valid choice.  Baililng ..."
			exit 1
		fi
	else
		echo -e "[!] Project already exists"
	fi

}

# Project home and subdir creation
create_project(){
	home="$1"
	project_home="/projects/${home}"

	echo -e "[+] Creating ${project_home}"
	
	for d in "${project_dir_tree[@]}"
	do
		echo -e "[+] ${d}"
		mkdir -p ${project_home}/${d}
	done

	for d in "${dscan_tree[@]}"
	do
		echo -e "[+] daily_scans/${d}"
		mkdir ${project_home}/daily_scans/${d}
	done
	
	echo -e "[+] Creating CONFIG file"
	echo -e "project_home:$project_home" >> $project_home/$home-project.cfg

	chgrp -R ${pentest_grp} ${project_home}

	exit 0
}

check_project_root
check_project_home
