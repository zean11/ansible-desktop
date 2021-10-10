#!/bin/bash

# find appropriate package manager
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

package="ansible git"

sudo ${package_manager} ${package}

# ensure git repo
mkdir -p $HOME/dev/
git clone https://gitlab.com/martin.goerz/ansible-desktop.gitlab $HOME/dev/ansible-desktop/

# change to working dir
cd $HOME/dev/ansible-desktop/

# make sure requirements are installed
sudo ansible-galaxy install -r requirements.yml

# run ansible
sudo ansible-playbook local.yml 
