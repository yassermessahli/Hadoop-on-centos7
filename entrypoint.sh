#!/usr/bin/env bash

echo "Starting SSH..."
/usr/sbin/sshd

echo "Starting HDFS & YARN..."
${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/sbin/start-yarn.sh

# Keep container alive
tail -f /dev/null
