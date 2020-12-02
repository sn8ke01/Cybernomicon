#####################################
# Author: Multi
# Function: Install Greenbone from source 
# Note: Works on Ubuntu 20.04
######## TODO ########################

# Add "echo" Install status messages
# Update vim tasks to take place automaticly 

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


echo -e "$info Ubuntu 20.04 Greenbone GVM 11 Install Script"
echo -e "$info Process pulled from: https://kifarunix.com/install-and-setup-gvm-11-on-ubuntu-20-04/"

echo -e "$info APT Update"
apt update &

echo -e "$info APT Upgrade"
apt upgrade &

echo -e "$info Adding user: gvm"
useradd -r -d /opt/gvm -c "GVM User" -s /bin/bash gvm &
mkdir /opt/gvm &
chown gvm:gvm /opt/gvm &
echo -e "$done User added"


## Requird Build Tools
echo -e "$info Installing all required packages."
echo -e "$info This is a lot so it could take some time."
apt install gcc g++ make bison flex libksba-dev curl redis libpcap-dev \
cmake git pkg-config libglib2.0-dev libgpgme-dev nmap libgnutls28-dev uuid-dev \
libssh-gcrypt-dev libldap2-dev gnutls-bin libmicrohttpd-dev libhiredis-dev \
zlib1g-dev libxml2-dev libradcli-dev clang-format libldap2-dev doxygen \
gcc-mingw-w64 xml-twig-tools libical-dev perl-base heimdal-dev libpopt-dev \
libsnmp-dev python3-setuptools python3-paramiko python3-lxml python3-defusedxml python3-dev gettext python3-polib xmltoman \
python3-pip texlive-fonts-recommended texlive-latex-extra --no-install-recommends xsltproc &
echo -e "$done Packages installed"

## Yarn Install
echo -e "$info Adding Yarn repo and keys"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &
echo -e "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &
echo -e "$done Complete"

## Update again
echo -e "$info APT Update to get Yarn Repo"
apt update &
echo -e "$done Complete"

echo -e "$info Installing Yarn"
apt install yarn -y &
echo -e "$done Complete"

## Postgresql Install
echo -e "$info Installing Postgresql"
apt install postgresql postgresql-contrib postgresql-server-dev-all &
echo -e "$done Complete"

echo -e "$info creating Users and DB"
sudo -Hiu postgres &
createuser gvm &
createdb -O gvm gvmd &

psql gvmd
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
\q
exit

systemctl restart postgresql
systemctl enable postgresql

## BUILD from SOURCE ##

su - gvm
mkdir /tmp/gvm-source
cd /tmp/gvm-source
git clone -b gvm-libs-11.0 https://github.com/greenbone/gvm-libs.git
git clone https://github.com/greenbone/openvas-smb.git
git clone -b openvas-7.0 https://github.com/greenbone/openvas.git
git clone -b ospd-2.0 https://github.com/greenbone/ospd.git
git clone -b ospd-openvas-1.0 https://github.com/greenbone/ospd-openvas.git
git clone -b gvmd-9.0 https://github.com/greenbone/gvmd.git
git clone -b gsa-9.0 https://github.com/greenbone/gsa.git

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH
cd gvm-libs
mkdir build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install
cd ../../openvas-smb/
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

## Build and Install OpenVas
cd ../../openvas

mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

### If you encounter the error, ...error: ‘pcap_lookupdev’ is deprecated: use 'pcap_findalldevs'... while compiling openvas, edit the CMakeLists.txt file and replace the line as shown below.

echo -e "$alert vim ../../openvas/CMakeLists.txt
	...
	#set (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${COVERAGE_FLAGS}")
	set (CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -Werror -Wno-error=deprecated-declarations")
	...
	"

# rerun make install

# Default Redis config file /etc/redis/redis.conf

exit

ldconfig

cp /tmp/gvm-source/openvas/config/redis-openvas.conf /etc/redis/
chown redis:redis /etc/redis/redis-openvas.conf
echo -e "db_address = /run/redis-openvas/redis.sock" > /opt/gvm/etc/openvas/openvas.conf
chown gvm:gvm /opt/gvm/etc/openvas/openvas.conf
usermod -aG redis gvm
echo -e "net.core.somaxconn = 1024" >> /etc/sysctl.conf
echo -e 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
sysctl -p

## To avoid creation of latencies and memory usage issues with Redis, disable Linux Kernel’s support for Transparent Huge Pages (THP). To easily work around this, create a systemd service unit for this purpose.

vim /etc/systemd/system/disable_thp.service

[Unit]
Description=Disable Kernel Support for Transparent Huge Pages (THP)

[Service]
Type=simple
ExecStart=/bin/sh -c "echo -e 'never' > /sys/kernel/mm/transparent_hugepage/enabled && echo -e 'never' > /sys/kernel/mm/transparent_hugepage/defrag"

[Install]
WantedBy=multi-user.target

#### 
systemctl daemon-reload

systemctl enable --now disable_thp

systemctl enable --now redis-server@openvas

## Update Sudo File
echo -e "gvm ALL = NOPASSWD: /opt/gvm/sbin/openvas" > /etc/sudoers.d/gvm

visudo
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/gvm/sbin"

###
echo -e "gvm ALL = NOPASSWD: /opt/gvm/sbin/gsad" >> /etc/sudoers.d/gvm

### 

su - gvm

greenbone-nvt-sync

sudo openvas --update-vt-info

## Build and install GVM 

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

cd /tmp/gvm-source/gvmd
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

## Build Greenbone Sec Assistant

##CURRENT STATE - PWD = /tmp/gvm-source/gsa/build
cd ../../gsa
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make  ## Failed first attempt due to memory issues.  Upgraded droplet from 1 to 2GB of memory
make install
## Update GVM CERT and SCAP data from the feed servers;

greenbone-scapdata-sync
greenbone-certdata-sync

## Cert creation
gvm-manage-certs -a

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

mkdir -p /opt/gvm/lib/python3.8/site-packages/
export PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
cd /tmp/gvm-source/ospd
python3 setup.py install --prefix=/opt/gvm

cd ../ospd-openvas
python3 setup.py install --prefix=/opt/gvm

## Start GVM as gvm user
/usr/bin/python3 /opt/gvm/bin/ospd-openvas \
--pid-file /opt/gvm/var/run/ospd-openvas.pid \
--log-file /opt/gvm/var/log/gvm/ospd-openvas.log \
--lock-file-dir /opt/gvm/var/run -u /opt/gvm/var/run/ospd.sock

gvmd --osp-vt-update=/opt/gvm/var/run/ospd.sock

sudo gsad

### KILL services before moving on -- DONE


vim /etc/systemd/system/openvas.service
[Unit]
Description=Control the OpenVAS service
After=redis.service
After=postgresql.service

[Service]
ExecStartPre=-rm -rf /opt/gvm/var/run/ospd-openvas.pid /opt/gvm/var/run/ospd.sock /opt/gvm/var/run/gvmd.sock
Type=simple
User=gvm
Group=gvm
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin
Environment=PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
ExecStart=/usr/bin/python3 /opt/gvm/bin/ospd-openvas \
--pid-file /opt/gvm/var/run/ospd-openvas.pid \
--log-file /opt/gvm/var/log/gvm/ospd-openvas.log \
--lock-file-dir /opt/gvm/var/run -u /opt/gvm/var/run/ospd.sock
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

### Start Services
systemctl daemon-reload
systemctl start openvas
systemctl status openvas


##ENable on system boot

systemctl enable openvas

##GSA Service File
vim /etc/systemd/system/gsa.service
[Unit]
Description=Control the OpenVAS GSA service
After=openvas.service

[Service]
Type=simple
User=gvm
Group=gvm
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin
Environment=PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
ExecStart=/usr/bin/sudo /opt/gvm/sbin/gsad
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
###

vim /etc/systemd/system/gsa.path
[Unit]
Description=Start the OpenVAS GSA service when gvmd.sock is available

[Path]
PathChanged=/opt/gvm/var/run/gvmd.sock
Unit=gsa.service

[Install]
WantedBy=multi-user.target

##
vim /etc/systemd/system/gvm.service

[Unit]
Description=Control the OpenVAS GVM service
After=openvas.service

[Service]
Type=simple
User=gvm
Group=gvm
Environment=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin
Environment=PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
ExecStart=/opt/gvm/sbin/gvmd --osp-vt-update=/opt/gvm/var/run/ospd.sock
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

##
vim /etc/systemd/system/gvm.path
[Unit]
Description=Start the OpenVAS GVM service when opsd.sock is available

[Path]
PathChanged=/opt/gvm/var/run/ospd.sock
Unit=gvm.service

[Install]
WantedBy=multi-user.target

## Reload 
systemctl daemon-reload
systemctl enable --now gvm.{path,service}
systemctl enable --now gsa.{path,service}

### Cfreate GVM Scanner
sudo -Hiu gvm gvmd --create-scanner="Kifarunix-demo OpenVAS Scanner" --scanner-type="OpenVAS" --scanner-host=/opt/gvm/var/run/ospd.sock
sudo -Hiu gvm gvmd --get-scanners

#output
08b69003-5fc2-4037-a479-93b440211c73  OpenVAS  /tmp/ospd.sock  0  OpenVAS Default
6acd0832-df90-11e4-b9d5-28d24461215b  CVE    0  CVE
a05cfceb-dd52-42e7-bae0-71ee9a7d2a6e  OpenVAS  /opt/gvm/var/run/ospd.sock  9390  Kifarunix-demo OpenVAS Scanner

sudo -Hiu gvm gvmd --verify-scanner=a05cfceb-dd52-42e7-bae0-71ee9a7d2a6e

sudo -Hiu gvm gvmd --create-user gvmadmin
#output
User created with password '258551ee-2feb-42a8-b310-e49834c613d1'.

sudo -Hiu gvm gvmd --create-user gvmadmin --password=aninjaisbetterthanapirate

## Reset Password

sudo -Hiu gvm gvmd --user=<USERNAME> --new-password=<PASSWORD>

#Firewall change depending on setup
ufw allow 443/tcp




