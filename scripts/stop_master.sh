#!/bin/bash

set -e

kill -9 `cat /qingstor/run/qfs_master.pid`

exit 0
