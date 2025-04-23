# Hadoop configuration on CentOS 7

To run the container, use the following command:

```bash
docker run -it --name hadoop -p 50070:50070 -p 50075:50075 -p 8088:8088 -p 8042:8042 -p 19888:19888 -p 22:22 yassermessahli/hadoop-on-centos7:estin
```
