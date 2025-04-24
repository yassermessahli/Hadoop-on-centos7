FROM eurolinux/centos-7:latest

# Install all required dependencies for Hadoop and SSH functionality
RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-devel openssh-server openssh-clients wget tar vim dos2unix && \
    yum clean all

# Download the specified Hadoop version and extract it to /opt
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.9.2/hadoop-2.9.2.tar.gz -P /opt && \
    tar -xzf /opt/hadoop-2.9.2.tar.gz -C /opt && \
    rm -f /opt/hadoop-2.9.2.tar.gz

# Move the extracted Hadoop directory to a standard location
RUN mv /opt/hadoop-2.9.2 /opt/hadoop

# Set environment variables for Java and Hadoop to ensure all tools and scripts work correctly
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

# Generate SSH keys and configure passwordless SSH for Hadoop operations
RUN ssh-keygen -A && \
    mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Create Hadoop data directories and copy configuration files into the Hadoop config directory
RUN mkdir -p /opt/hadoop/hadoopdata/namenode /opt/hadoop/hadoopdata/datanode
COPY config/*.xml /opt/hadoop/etc/hadoop/

# formatting namenode and datanode
RUN /opt/hadoop/bin/hdfs namenode -format -force

# Expose ports
EXPOSE 50070 50075 8088 8042

# Add entrypoint script to root
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# Use the entrypoint script to start services
ENTRYPOINT ["/entrypoint.sh"]
