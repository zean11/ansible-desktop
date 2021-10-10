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

echo "Ensuring that git and ansible is installed"
sudo ${package_manager} ${package}

# ensure git repo
echo "Ensuring ansible-desktop repository"

ANSIBLE_GIT_HEAD=$HOME/dev/ansible-desktop/.git/HEAD
if [ ! -f "$ANSIBLE_GIT_HEAD" ]; then
  echo "$ANSIBLE_GIT_HEAD does not exist."
  mkdir -p $HOME/dev/
  git clone https://gitlab.com/martin.goerz/ansible-desktop.git $HOME/dev/ansible-desktop/
fi

# change to working dir
cd $HOME/dev/ansible-desktop/

# make sure requirements are installed
echo "Ensuring ansible galaxy requirements"
sudo ansible-galaxy install -r requirements.yml

# run ansible
echo "Runninng playbook"
sudo ansible-playbook local.yml 
