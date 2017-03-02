#!/bin/bash

argc=$#
arg1=$1
arg2=$2

if [ 2 -ne $argc ]
then
    echo "argument master[slave] port"
    exit 0
fi

echo "node server start... $arg1 port $arg2"

export AOF5_PROJECT=lgaca
export AOF5_HOME=/home/wwwroot/$AOF5_PROJECT-ui
export NODE_HOME=/home/app/node-v0.8.14-linux-x64
export LOG4J_HOME=/home/log4j/$AOF5_PROJECT

export PATH=$PATH:$NODE_HOME/bin
export PATH

nohup node $AOF5_HOME/web/nodejs/server.js service $arg1 $arg2 > $LOG4J_HOME/node.server.log &
