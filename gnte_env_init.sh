#!/bin/bash

BASEDIR=`pwd`
n=1
first_node_id_line=`grep -rn -m 1 node_id scripts/qfs_master.yaml | awk -F : '{print $1}'`
for g in bj10.250.1.2 bj10.250.2.2 bj10.250.3.2;
do
    echo "${g}: update apt sources"
    docker cp /etc/apt/sources.list.d/qingstor.list ${g}:/etc/apt/sources.list.d/qingstor.list
    docker cp /etc/apt/trusted.gpg ${g}:/etc/apt/trusted.gpg
    echo "${g}: create /qingstor/{etc,run} dirs"
    docker exec -d ${g} mkdir /qingstor/etc -p
    docker exec -d ${g} mkdir /qingstor/run -p
    #docker exec -d ${g} mkdir /qingstor/bin -p
    docker exec -d ${g} mkdir /qingstor/data/node${n}/master -p
    echo "${g}: copy qfs_master.yaml to /qingstor/etc"
    docker cp ${BASEDIR}/scripts/qfs_master.yaml ${g}:/qingstor/etc/qfs_master.yaml
    docker cp ${BASEDIR}/scripts/install_master.sh ${g}:/qingstor/bin/install_master.sh
    docker cp ${BASEDIR}/scripts/start_master.sh ${g}:/qingstor/bin/start_master.sh
    docker cp ${BASEDIR}/scripts/stop_master.sh ${g}:/qingstor/bin/stop_master.sh
    echo "${g}: config qfs_master.yaml"
    docker exec -d ${g} sed -i 's#raft_addr: "172.20.1.3:9991"#raft_addr: "10.250.'${n}'.2:9991"#g' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i ${first_node_id_line}'s#node_id: "1"#node_id: "'${n}'"#' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i 's/172.20.1.3:9991/10.250.1.2:9991/g' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i 's/172.20.1.4:9991/10.250.2.2:9991/g' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i 's/172.20.1.5:9991/10.250.3.2:9991/g' /qingstor/etc/qfs_master.yaml
    #docker exec -d ${g} sed -i 's/\/qingstor\/log/\/qingstor\/log\/node'${n}'/g' /qingstor/etc/qfs_master.yaml
    #docker exec -d ${g} sed -i 's/\/qingstor\/data/\/qingstor\/data\/node'${n}'/g' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i 's#/qingstor/log#/qingstor/log/node'${n}'#g' /qingstor/etc/qfs_master.yaml
    docker exec -d ${g} sed -i 's#/qingstor/data#/qingstor/data/node'${n}'#g' /qingstor/etc/qfs_master.yaml
    echo "${g}: apt update..."
    docker exec -d ${g} apt update
    let n++
done

echo "finished"
exit 0
