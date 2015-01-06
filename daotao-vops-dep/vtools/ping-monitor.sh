#!/bin/bash
#@: VDCIT@OpenStack
#@: Test ip cho cac may
#@ Monitor
###############################

cho -e "\e[92m Ping toi dai 10.30.0.0  \e[0m"
for i in {1,11,21,31,32,33,101,111}; do timeout 1 ping -c 1 10.30.0.$i >/dev/null && echo $_>>ping-monitor30.txt; done

awk '{print $1}' ping-monitor30.txt | sort | uniq -c | sort -n
wc -l < ping-monitor30.txt