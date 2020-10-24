## Install Dotnet SDK 3.1 (Ubuntu 20.04 LTS)
 
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
apt update
apt install -y apt-transport-https
apt update
apt install -y dotnet-sdk-3.1
 
## Install Covenant
git clone --recurse-submodules https://github.com/cobbr/Covenant
cd Covenant/Covenant
dotnet run