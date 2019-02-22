#!/bin/bash

for g in bj10.250.1.2 bj10.250.2.2 bj10.250.3.2;
do
    echo "${g}: start qfs-master"
    docker exec -d ${g} nohup /bin/sh /qingstor/bin/start_master.sh
done
echo "finished"
exit 0
