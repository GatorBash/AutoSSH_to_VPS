#!/bin/bash

ssh=/lib/systemd/system/autossh.service
set=/etc/NetworkManager/dispatcher.d/set_setrics.sh

#switch to root, update and upgrade
if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root; run \"sudo -i\" this will log you into root." 
   exit 1
fi
apt update -y
wait
#apt full-upgrade -y
#wait

#create ifmetric script and move to NetworkManger dir
touch set_metrics.sh
apt install ifmetric -y
wait
echo "Are you using a cell hat?"
read -r yn
if [ "$yn" == y ]
then
   echo "ifmetric wwan0 1" >> set_metrics.sh
   echo "ifmetric wlan1 2" >> set_metrics.sh
   echo "ifmetric eth0 3" >> set_metrics.sh
   echo "ifmetric wlan0 4" >> set_metrics.sh
else
   echo "ifmetric wlan0 1" >> $set
   echo "ifmetric wlan1 2" >> $set
   echo "ifmetric eth0 3" >> $set
fi
chomod +x set_metrics.sh
cp set_metrics.sh /etc/NetworkManager/dispatcher.d/

clear
echo "Are you still there?"
sleep 3
#configure ssh
echo "ok here we go again"
sudo apt install autossh
wait
cd
mkdir .ssh
cd .ssh
echo "When it asks for you to set a password."
echo "Just press enter."
echo "Don't fuck it up loser."
echo "Remember what you named it."
echo "ready"
sleep 1
clear
echo "3"
sleep 1
clear
echo "2"
sleep 1
clear
echo "1"
sleep 1
clear
ssh-keygen -t rsa -b 4096
echo "what did you name the cert?"
echo "type it in exactly how you did when you made it."
read -r key
clear
sleep 2
echo "What port do you want to use for ssh on the server?"
read -r port

#creating the autossh.service file
touch $ssh
echo "what is the ip of your server?"
read -r serv
echo "what is the user you're logging into on the server?"
read -r use
echo "[Unit]" >> $ssh
echo "Description=AutoSSH Tunnel Service on Port $port" >> $ssh
echo "After=network.target" >> $ssh
echo " " >> $ssh
echo "[Service]" >> $ssh
echo "Environment=\"AUTOSSH_GATETIME=0\"" >> $ssh
echo "Environment=\"AUTOSSH_FIRST_POLL=30\"" >> $ssh
echo "Environment=\"AUTOSSH_POLL=60\"" >> $ssh
echo "ExecStart=/usr/bin/autossh -M 667 -N -i ~/.ssh/$key -R $port:local:22 $use@$serv -p 22" >> $ssh
echo " " >> $ssh
echo "[Install]" >> $ssh
echo "WantedBy=multi-user.target" >> $ssh
clear
sleep 5

#starting daemon
systemctl daemon-reload
wait
systemctl enable autossh
wait
systemctl start autossh
wait
echo "make sure you do a \"systemctl status autossh\" and ensure that you have a green bubble on it"

