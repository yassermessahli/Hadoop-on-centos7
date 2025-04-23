FROM eurolinux/centos-7:latest

# --- Install system dependencies ---
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-devel openssh-server openssh-clients wget tar vim && \
    yum clean all

# Set Java home environment variable
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk

# --- Download & install Hadoop ---
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz -P /opt && \
    tar -xzf /opt/hadoop-2.9.2.tar.gz -C /opt && \
    rm -f /opt/hadoop-2.9.2.tar.gz

# Set Hadoop home environment
ENV HADOOP_HOME=/opt/hadoop

# Move extracted Hadoop
RUN mv /opt/hadoop-2.9.2 ${HADOOP_HOME}

# --- SSH setup for Hadoop ---
RUN ssh-keygen -A && \
    mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Set Java & Hadoop environment variables
ENV HADOOP_INSTALL=/opt/hadoop \
    HADOOP_MAPRED_HOME=/opt/hadoop \
    HADOOP_COMMON_HOME=/opt/hadoop \
    HADOOP_HDFS_HOME=/opt/hadoop \
    YARN_HOME=/opt/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/opt/hadoop/lib/native \
    HADOOP_OPTS="-Djava.library.path=/opt/hadoop/lib/native" \
    PATH=$PATH:/usr/lib/jvm/jre-1.8.0-openjdk/bin:/opt/hadoop/bin:/opt/hadoop/sbin

# --- Configure Hadoop ---
RUN mkdir -p ${HADOOP_HOME}/hadoopdata/namenode ${HADOOP_HOME}/hadoopdata/datanode
COPY config/*.xml ${HADOOP_HOME}/etc/hadoop/

# Add entrypoint script
COPY entrypoint.sh /opt/hadoop/entrypoint.sh
RUN chmod +x /opt/hadoop/entrypoint.sh

# Expose ports
EXPOSE 50070 8088 8042 22

# Format NameNode
RUN ${HADOOP_HOME}/bin/hdfs namenode -format -force

# Use the entrypoint script to start services
ENTRYPOINT ["/opt/hadoop/entrypoint.sh"]
