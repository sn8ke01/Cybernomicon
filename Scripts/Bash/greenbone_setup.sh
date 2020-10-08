echo "Ubuntu 20.04 Greenbone GVM 11 Install Script"
apt update
apt upgrade
useradd -r -d /opt/gvm -c "GVM User" -s /bin/bash gvm
mkdir /opt/gvm
chown gvm:gvm /opt/gvm

## Requird Build Tools
apt install gcc g++ make bison flex libksba-dev curl redis libpcap-dev \
cmake git pkg-config libglib2.0-dev libgpgme-dev nmap libgnutls28-dev uuid-dev \
libssh-gcrypt-dev libldap2-dev gnutls-bin libmicrohttpd-dev libhiredis-dev \
zlib1g-dev libxml2-dev libradcli-dev clang-format libldap2-dev doxygen \
gcc-mingw-w64 xml-twig-tools libical-dev perl-base heimdal-dev libpopt-dev \
libsnmp-dev python3-setuptools python3-paramiko python3-lxml python3-defusedxml python3-dev gettext python3-polib xmltoman \
python3-pip texlive-fonts-recommended texlive-latex-extra --no-install-recommends xsltproc

## Yarn Install
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list


## Update again
apt update 
apt install yarn -y

## Postgresql Install
apt install postgresql postgresql-contrib postgresql-server-dev-all

sudo -Hiu postgres
createuser gvm
createdb -O gvm gvmd

psql gvmd
create role dba with superuser noinherit;
grant dba to gvm;
create extension "uuid-ossp";
\q
exit

systemctl restart postgresql
systemctl enable postgresql

## BUILD from SOURCE ##


