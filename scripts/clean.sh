#!/bin/bash -x

docker rm -f bj10.250.1.2
docker rm -f bj10.250.2.2
docker rm -f bj10.250.3.2
docker network rm CovenantSQL_testnet
