#!/usr/bin/env bash

# Start the SSH daemon to allow remote connections (required for Hadoop)
echo "Starting SSH..."
/usr/sbin/sshd

# Configure SSH to disable strict host key checking
echo "Host *
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null" > /root/.ssh/config

# Ensure all required environment variables are available in SSH sessions for Hadoop commands
cat <<EOF >> /root/.bashrc
export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk \
export HADOOP_HOME=/opt/hadoop \
export HADOOP_INSTALL=/opt/hadoop \
export HADOOP_MAPRED_HOME=/opt/hadoop \
export HADOOP_COMMON_HOME=/opt/hadoop \
export HADOOP_HDFS_HOME=/opt/hadoop \
export YARN_HOME=/opt/hadoop \
export HADOOP_COMMON_LIB_NATIVE_DIR=/opt/hadoop/lib/native \
export HADOOP_OPTS="-Djava.library.path=/opt/hadoop/lib/native" \
export PATH=$PATH:/usr/lib/jvm/jre-1.8.0-openjdk/bin:/opt/hadoop/bin:/opt/hadoop/sbin
EOF

echo "Starting HDFS & YARN..."
${HADOOP_HOME}/sbin/start-dfs.sh
${HADOOP_HOME}/sbin/start-yarn.sh

echo "$(date): Hadoop started successfully on CentOS instance!"
echo "-------------------------------------------------------------"
echo "You are now in an interactive terminal with root access."
echo "You can modify Hadoop configurations in /opt/hadoop/etc/hadoop/"
echo "HDFS web UI: http://localhost:50070"
echo "YARN web UI: http://localhost:8088"
echo "Type 'exit' to stop the container."
echo "-------------------------------------------------------------"

# Keep container alive or provide interactive shell
if [ $# -gt 0 ]; then
  exec "$@"
else
  exec /bin/bash
fi
