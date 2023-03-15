FROM centos:centos8
# Fix centos8 "No URLs in mirrorlist" error
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*
# Oracle database installation
ENV ORACLE_DATABASE_PREINSTALL_URL "https://yum.oracle.com/repo/OracleLinux/OL8/appstream/x86_64/getPackage/oracle-database-preinstall-21c-1.0-1.el8.x86_64.rpm"
ENV ORACLE_DATABASE_XE_URL "https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm"

# Set Oracle environment variables
ENV ORACLE_PASSWORD=root
ENV ORACLE_SID=XE 
ENV ORAENV_ASK=NO
ENV ORACLE_DOCKER_INSTALL=true

# Get installers
WORKDIR /tmp/oracle-installer
RUN curl -L -o oracle-database-preinstall-21c-1.0-1.x86_64.rpm $ORACLE_DATABASE_PREINSTALL_URL
RUN curl -L -o oracle-database-xe-21c-1.0-1.x86_64.rpm $ORACLE_DATABASE_XE_URL

# Installing Oracle database
WORKDIR /oracle_logs
RUN yum -y localinstall /tmp/oracle-installer/oracle-database-preinstall-21c-1.0-1.x86_64.rpm  > XEsilentinstall.log 2>&1
RUN yum -y localinstall /tmp/oracle-installer/oracle-database-xe-21c-1.0-1.x86_64.rpm > XEsilentinstall.log 2>&1
RUN (echo "${ORACLE_PASSWORD}"; echo "${ORACLE_PASSWORD}";) | /etc/init.d/oracle-xe-21c configure >> XEsilentinstall.log 2>&1

# Cleaning installer
RUN rm -rf /tmp/oracle-installer
WORKDIR /

# Init systemd & start Oracle instance
ENTRYPOINT  /usr/sbin/init & \
    . oraenv && \
    /etc/init.d/oracle-xe-21c start && \
    /bin/bash