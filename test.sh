#!/bin/bash

printf "audit line \n"
host=$(hostname)
ipv4=$(ip -4 addr show  ens33|grep -i inet |awk '{print $2}') 
kernel=`uname -r`

#fdisk -l

#dmidecode -t 17 |grep "size.*MB" |awk'{s+=$2}END{print s/1024}'
memsize=`dmidecode -t 17 | grep "Size.*MB" | awk '{s+=$2} END {print s / 1024}'`
cpu=`cat /proc/cpuinfo |grep -i cores --color |wc -l`
#ram1=$(getconf -a | grep PAGES | awk 'BEGIN {total = 1} {if (NR == 1 || NR == 3) total *=$NF} END {print total/1073741824}')
#ram2=`$ram1 | awk '{printf("%d\n",$1 + 0.5)}'`
firewall=$(systemctl status firewalld  2>/dev/null |grep -i 'Active:' |awk '{print $2}')
firewall2=`systemctl status firewalld 2>/dev/null |grep -i Loaded: |awk '{print $4}'`
auth=`systemctl status sssd  2>/dev/null |grep -i Active: |awk '{print $2}'`
auth2=`systemctl status sssd  2>/dev/null |grep -i Loaded: |awk '{print $4}'`
nimsoft=$(systemctl status nimbus 2>/dev/null |grep -i Active: |awk '{print $2}' ) 
nimsoft2=`systemctl status nimbus  2>/dev/null |grep -i Loaded: |awk '{print $4}'`
NetMan=$(systemctl status NetworkManager  2>/dev/null |grep -i Active: |awk '{print $2}')
NetMan2=$(systemctl status NetworkManager  2>/dev/null |grep -i Loaded: |awk '{print $4}')
swp=$(free -m |grep Swap: |  awk '{s+=$2} END {print s / 1024}'| awk '{printf("%d\n",$1 + 0.5)}')
trip='ps -ef |grep trip'
echo "####################################################################"
printf "\n########## \t Audit Report of $host############ \n"
printf  "\nHostname:\t\t\t$host"
printf "\nIP address:\t\t\t$ipv4"
printf "\nKernel Verson:\t\t\t$kernel"
printf "\nNo. of CPU:\t\t\t$cpu cores"
printf "\nSize of RAM:\t\t\t$memsize GB"
printf "\nswap Memory:\t\t\t$swp GB"
printf "\nfirewall status:\t\t$firewall\t$firewall2"
#echo "sssd status :		$auth"
#echo "nimsoft status :		$nimsoft"
#sw=$((`free -m |grep Swap: |awk '{print $2}'`/1024))
if [ "$NetMan" = "active" ] || [ "$NetMan" = "inactive" ]; then
printf "\nNetworkManager status:\t\t$NetMan\t$NetMan2"
else
printf "\nNetworkManager status:\t\tnot installed"
fi

if [ "$auth" = "active" ] || [ "$auth" = "inactive" ]; then
printf "\nsssd status:\t\t\t$auth\t$auth2"
else
printf "\nsssd status:\t\t\tnot installed"
fi

if [ "$nimsoft" = "active" ]  || [ "$nimsoft" = "inactive" ]; then
printf "\nnimsoft status:\t\t\t$nimsoft  $nimsoft2"
else
printf "\nnimsoft status:\t\t\tnot-installed"
fi
#disk1=$(lsblk /dev/sda |grep -w sda |awk '{print $4}')
disksz=$(lsblk |grep -w disk |awk '{print $4}'| tr '\n' ' ')
printf "\ndisk sizes:\t\t\t$disksz"
printf "\n\ndisk mount points:\n\n"
#lsblk |awk '{print "		" $2" 		"$6}'
df -h
printf "\n\nTripwire Status:\n\n"
ps -ef |grep -i tripwire
