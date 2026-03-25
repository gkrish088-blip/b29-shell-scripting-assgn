#!/bin/bash
function getIpUsingIP(){
echo "$(ip a | grep -w inet | grep -v 127.0.0.1 | grep -E -o 'inet\ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
return 0
} 
function getMacUsingIP(){
echo "$(ip a | grep -w ether | grep -E -o 'ether\ [a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}' | grep -E -o '[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}')"
}
function getIpUsingIfconfig(){
echo "$(ifconfig | grep -E -o 'inet\ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v '127.0.0.1' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
}
function getMacUsingIfconfig(){
echo "$(ifconfig | grep ether | grep -E -o '[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}\:[a-zA-Z0-9]{2}' )"
}
function displayMacAndIp(){
if IP=$(getIpUsingIP) && MAC=$(getMacUsingIP);then
echo "IP ADDRESS :$IP"
mapfile -t array< <(echo "$MAC")
for i in "${!array[@]}";do
	echo "MAC ADDRESS[$i]: ${array[$i]}"
done
elif IP=$(getIpUsingIfconfig) && MAC=$(getMacUsingIfconfig);then
echo "IP ADDRESS :$IP"
mapfile -t array< <(echo "$MAC")
for i in "${!array[@]}";do
        echo "MAC ADDRESS[$i]: ${array[$i]}"
done
else
echo "Please install either ip or ifconfig"
fi
}
displayMacAndIp
function getactivePorts(){
echo "$(ss -tuln state established | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\:[0-9]{1,5}' | grep -E '10.70.71.213\:[0-9]{1,5}')" 
}
function getNoofactivePorts() {
mapfile -t array < <(getactivePorts)
count=0
for i in "${!array[@]}";do
	((count = count+1))
	echo "ACTIVE PORTS: ${array[$i]}"	
done
echo "NO OF OPEN PORTS : '$count'"
}
getNoofactivePorts
