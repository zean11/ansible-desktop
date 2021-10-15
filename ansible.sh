#!/bin/bash

sudo echo "Ensuring privileges"

echo "Determining package manager"
declare -A osInfo;
osInfo[/etc/debian_version]="apt-get install -y"
osInfo[/etc/alpine-release]="apk --update add"
osInfo[/etc/centos-release]="yum install -y"
osInfo[/etc/fedora-release]="dnf install -y"

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

echo "Ensuring that git and ansible is installed"
package="ansible git"
sudo ${package_manager} ${package}

echo "Ensuring ansible galaxy requirements"
curl "https://gitlab.com/api/v4/projects/martin.goerz%2Fansible-desktop/repository/files/requirements.yml/raw?ref=main" > requirements.yml
sudo ansible-galaxy install -r requirements.yml
rm requirements.yml

echo "Runninng ansible-pull"
/usr/bin/ansible-pull -o --track-subs -U https://gitlab.com/martin.goerz/ansible-desktop.git 
