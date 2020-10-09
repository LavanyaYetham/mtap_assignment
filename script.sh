#!/bin/bash
echo "Server_IP, Server_Status, Ram_Usage, Process_List" > ram_usage.csv # creating csv file with heads
for line in `cat inputs.csv`                              # reading the inputs.csv file for inputs
do
    n=`echo $line | awk -F"," '{print $1}'`
    echo $n
    m=`echo $line | awk -F"," '{print $2}'`
    if [ -z "$m" ]
    then
        m=3
    fi
    echo $m
    ping -c 1 $n > /dev/null
    pingResult=`echo $?`
    if [ $pingResult -eq 0 ]
    then
        serverStatus="Reachable"
    else
        serverStatus="Unreachable"
    fi
    echo $serverStatus
    Memory=` ssh root@$n "free -m | grep "Mem:""`
    Memory_Usage=`echo $Memory | awk '{print $3}'`
    echo $Memory_Usage
    m=$(($m+1))
    procList=`ps aux --sort -rss | head -n $m | grep -v "USER" | awk '{print $11}'`
    echo $procList
    echo  "$n, $serverStatus, $Memory_Usage, "$procList"" >> ram_usage.csv 
    
done 
