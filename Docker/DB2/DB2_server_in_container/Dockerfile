FROM centos:centos8
# Fix centos8 "No URLs in mirrorlist" error
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# Prerequisite to DB2 use
RUN yum install -y numactl

# Clean some stuff to be able to use systemd in the container
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Copy resources installer & response file
RUN mkdir -p /tmp/v11.5.8_linuxx64_server_dec/server_dec/
COPY ./resources/db2server.rsp /tmp/v11.5.8_linuxx64_server_dec/server_dec/
# Download installer (tar.gz) from IBM here : https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=1120&tabId=2932&p=null&h=null
# Replace following ADD with installer
ADD .v11.5.8_linuxx64_server_dec.tar.gz /tmp/v11.5.8_linuxx64_server_dec/

# Instance user creation
RUN useradd db2inst1
RUN usermod -a -G root db2inst1

# DB2 installation
RUN /tmp/v11.5.8_linuxx64_server_dec/server_dec/db2setup -r /tmp/v11.5.8_linuxx64_server_dec/server_dec/db2server.rsp -f sysreq

# Instance creation
RUN /opt/ibm/db2/V11.5/instance/db2icrt -u db2inst1 db2inst1
# DB2 nodes (aka network) file may contains invalid configuration
RUN echo "0 localhost 0" > /home/db2inst1/sqllib/db2nodes.cfg
# Correct db2 instance folder ownership
RUN chown db2inst1:db2inst1 -R /home/db2inst1/

# Sample database creation
USER db2inst1
ENV DB2HOME=/opt/ibm/db2/V11.5
ENV DB2INSTANCE=db2inst1
RUN /home/db2inst1/sqllib/adm/db2start
RUN /opt/ibm/db2/V11.5/bin/db2sampl || true

# Cleaning installer
USER root
RUN rm -rf /tmp/v11.5.8_linuxx64_server_dec/

# Init systemd, start Oracle instance, start DB2 instance and connect to DB2 sample database
ENTRYPOINT  /usr/sbin/init & \
    su db2inst1 && \
    /home/db2inst1/sqllib/adm/db2start && /home/db2inst1/sqllib/bin/db2 connect to sample && \
    /bin/bash