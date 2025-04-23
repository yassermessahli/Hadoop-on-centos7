#!/usr/bin/env bash

echo "Starting SSH..."
/usr/sbin/sshd



# ensure Hadoop/JAVA env vars are seen by remote SSH sessions
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

echo "Starting NameNode..."

# Ensure the logs directory exists
mkdir -p /opt/hadoop/logs

# Format the DataNode directory
${HADOOP_HOME}/bin/hdfs datanode -format -force

# Redirect NameNode logs to a file
${HADOOP_HOME}/bin/hdfs namenode >> /opt/hadoop/logs/namenode.log 2>&1 &
${HADOOP_HOME}/bin/hdfs datanode

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
