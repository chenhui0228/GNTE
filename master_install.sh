#!/bin/bash

for g in bj10.250.1.2 bj10.250.2.2 bj10.250.3.2;
do
    echo "${g}: apt install qfs-master"
    docker exec -d ${g} /bin/sh /qingstor/bin/install_master.sh
done
echo "finished"
exit 0
