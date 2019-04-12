#!/bin/bash
#
#
#############################################################################################
########		Linux Build Audit Scrip		#####################################
########		Author:  Radhikesh Dhakal	#####################################
########	This script will check all then post build configuration 	#############
########		Version 1.2			#####################################
########			UNCopyright		#####################################
#############################################################################################
#############################################################################################

printf "audit line \n"
host=$(hostname)
ipv4=$(ip -4 addr show  eno16777736|grep -i inet |awk '{print $2}') 
OS=`cat /etc/redhat-release`
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
sshstatus=$(systemctl status sshd  2>/dev/null |grep -i Active: |awk '{print $2}')
nlook=`nslookup $host|grep Name: | awk '{print $2}'`
status=$(subscription-manager status |grep Overall | awk '{print $3}')
trip=$(rpm -qa |grep dmidecode)
echo "####################################################################"
printf "\n##########Audit Report of $host############ \n"
printf  "\nHostname:\t\t\t$nlook"
printf "\nIP:\t\t\t\t$ipv4"
printf "\nOS Version:\t\t\t$OS"
printf "\nKernel Verson:\t\t\t$kernel"
printf "\nCPU:\t\t\t\t$cpu cores"
printf "\nRAM:\t\t\t\t$memsize GB"
printf "\nSWAP:\t\t\t\t$swp GB"
printf "\nRedHat Licence:\t\t\t$status"
printf "\nSSHD Status:\t\t\t$sshstatus"
printf "\nFirewall Status:\t\t$firewall\t$firewall2"
#echo "sssd status :		$auth"
#echo "nimsoft status :		$nimsoft"
#sw=$((`free -m |grep Swap: |awk '{print $2}'`/1024))
if [ "$NetMan" = "active" ] || [ "$NetMan" = "inactive" ]; then
printf "\nNetworkManager Status:\t\t$NetMan ;$NetMan2"
else
printf "\nNetworkManager Status:\t\tnot-installed"
fi

if [ "$auth" = "active" ] || [ "$auth" = "inactive" ]; then
printf "\nsssd Status:\t\t\t$auth; \t$auth2"
else
printf "\nsssd Status:\t\t\tnot-installed"
fi

if [ "$nimsoft" = "active" ]  || [ "$nimsoft" = "inactive" ]; then
printf "\nNimsoft Satus:\t\t\t$nimsoft  $nimsoft2"
else
printf "\nnimsoft status:\t\t\tnot-installed"
fi
#disk1=$(lsblk /dev/sda |grep -w sda |awk '{print $4}')
printf "\nTripwire Version:\t\t$trip"
disksz=$(lsblk |grep -w disk |awk '{print $4}'| tr '\n' ' ')
printf "\nHard Disks Size:\t\t$disksz"
printf "\n\nDisk Mount Points:\n"
#lsblk |awk '{print "		" $2" 		"$6}'
df -h | grep -v 'tmpfs'

printf "\nVerify ClamAV:\n"
rpm -qa |grep -i clamav




echo '############END OF SCRIPT##############'




