#!/usr/bin/env bash

echo "Starting SSH..."
/usr/sbin/sshd

# ensure Hadoop/JAVA env vars are seen by remote SSH sessions
cat <<EOF >> /root/.bashrc
export JAVA_HOME=${JAVA_HOME}
export HADOOP_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_COMMON_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HDFS_HOME}
export YARN_HOME=${YARN_HOME}
export PATH=${PATH}
EOF

echo "Starting HDFS & YARN..."
${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/sbin/start-yarn.sh

# fix ownership of the Hadoop logs directory
chown -R root:root /opt/hadoop/logs

echo "Hadoop started successfully!"

# Keep container alive or provide interactive shell
if [ $# -gt 0 ]; then
  exec "$@"
else
  exec /bin/bash
fi
