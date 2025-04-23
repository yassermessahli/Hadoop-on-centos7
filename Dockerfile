FROM eurolinux/centos-7:latest

# Install dependencies
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-devel openssh-server openssh-clients wget tar vim && \
    yum clean all

# Download & install Hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz -P /opt && \
    tar -xzf /opt/hadoop-2.9.2.tar.gz -C /opt && \
    rm -f /opt/hadoop-2.9.2.tar.gz

# Move extracted Hadoop
RUN mv /opt/hadoop-2.9.2 /opt/hadoop

# Set Java & Hadoop environment variables
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk \
    HADOOP_HOME=/opt/hadoop \
    HADOOP_INSTALL=/opt/hadoop \
    HADOOP_MAPRED_HOME=/opt/hadoop \
    HADOOP_COMMON_HOME=/opt/hadoop \
    HADOOP_HDFS_HOME=/opt/hadoop \
    YARN_HOME=/opt/hadoop \
    HADOOP_COMMON_LIB_NATIVE_DIR=/opt/hadoop/lib/native \
    HADOOP_OPTS="-Djava.library.path=/opt/hadoop/lib/native" \
    PATH=$PATH:/usr/lib/jvm/jre-1.8.0-openjdk/bin:/opt/hadoop/bin:/opt/hadoop/sbin

# SSH setup for Hadoop
RUN ssh-keygen -A && \
    mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Configure Hadoop
RUN mkdir -p /opt/hadoop/hadoopdata/namenode /opt/hadoop/hadoopdata/datanode
COPY config/*.xml /opt/hadoop/etc/hadoop/

# formatting namenode and datanode
RUN /opt/hadoop/bin/hdfs namenode -format -force

# Expose ports
EXPOSE 50070 8088 8042 22

# Add entrypoint script to root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use the entrypoint script to start services
ENTRYPOINT ["/entrypoint.sh"]
