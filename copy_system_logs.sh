#!/bin/bash

cat /var/log/system.log | grep "fail" >> mac_failed.log

[[ -f mac_failed.log ]] && tar -czf mac_failed.tar mac_failed.log || echo "File 'mac_failed.log' not found"

hosts=$(cat hosts)

for i in $hosts
do
    echo -n $i
    nc -z -G 2 $i 22 2>/dev/null
    if [[ $? -eq 0 ]]; then
      echo -n " --- Connection to port 22 succeeded"
      echo
      echo $(scp mac_failed.tar ec2-user@$i:~)
    else
      echo -n " --- Connection to port 22 failed"
    fi
    sleep 1
done



