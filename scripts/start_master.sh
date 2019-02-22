#!/bin/bash

set -e

nohup /qingstor/bin/qfs_master -conf /qingstor/etc/qfs_master.yaml &

exit 0
