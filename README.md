# Hadoop Configuration on CentOS 7

## Overview

This project provides a containerized single-node Hadoop environment running on CentOS 7. It includes a complete setup of Hadoop 2.9.2 with HDFS and YARN configured and ready to use.

Key components:

- **Hadoop 2.9.2**: A framework for distributed storage and processing of large data sets
- **HDFS**: Hadoop Distributed File System for reliable data storage
- **YARN**: Yet Another Resource Negotiator for job scheduling and resource management
- **MapReduce**: Programming model for large-scale data processing
- **SSH**: Configured for passwordless access required by Hadoop services

## run the container
the easiest way to run the container is to pull the official image of this repository just run this command:

```bash
docker pull yassermessahli/hadoop-on-centos7:estin
docker run -it --name hadoop-cluster -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8042:8042 yassermessahli/hadoop-on-centos7:estin
```

you will need:
- Docker installed on your system
- Internet connection for pulling base images and dependencies

alteratively , you can buil it yourself. follow these steps:
1. Clone this repository
2. Navigate to the project directory
3. Build and run the Docker image:

```bash
docker build -t hadoop-on-centos7 .
docker run -it --name hadoop-cluster -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8042:8042 hadoop-on-centos7
```

To test it. Access web interfaces by navigating to `http://localhost:<port>` in your browser.
The container exposes several ports for different Hadoop services:

| Port  | Service                      | Description                                          |
| ----- | ---------------------------- | ---------------------------------------------------- |
| 50070 | HDFS NameNode Web UI         | Monitor your HDFS filesystem, browse directories     |
| 50075 | HDFS DataNode Web UI         | DataNode information and logs                        |
| 8088  | YARN ResourceManager Web UI  | Monitor applications, cluster metrics, and scheduler |
| 8042  | YARN NodeManager Web UI      | Information about containers and node resources      |
| 19888 | MapReduce Job History Server | View completed MapReduce jobs and their statistics   |
| 22    | SSH                          | SSH access to the container                          |


## Additionals: configuration Files

All Hadoop configuration files are located in `/opt/hadoop/etc/hadoop/` within the container:

- `core-site.xml`: Core Hadoop configuration
- `hdfs-site.xml`: HDFS configuration
- `yarn-site.xml`: YARN configuration
- `mapred-site.xml`: MapReduce configuration

## Contributing

I welcome any contribution or issues you may encounter. Please feel free to open an issue or submit a pull request. Your feedback is valuable to improve this project!
