FROM centos:centos8
# Fix centos8 "No URLs in mirrorlist" error
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# Prerequisite to DB2 client installation
RUN yum install -y numactl

# Add user & environment variables
RUN useradd db2inst1
ENV DB2HOME=/opt/ibm/db2/V11.5
ENV DB2INSTANCE=db2inst1

# Copy installer & response file
# Download installer (tar.gz) from IBM here : https://epwt-www.mybluemix.net/software/support/trial/cst/programwebsite.wss?siteId=850&h=null&p=null
# Replace following ADD with installer
ADD resources/v11.5.4_linuxx64_client.tar.gz /tmp/v11.5.4_linuxx64_client/v11.5.4_linuxx64_client.tar.gz
ADD resources/db2client_response_file.rsp /tmp/v11.5.4_linuxx64_client/db2client.rsp

# Install DB2 client
RUN /tmp/v11.5.4_linuxx64_client/client/db2setup -r /tmp/v11.5.4_linuxx64_client/db2client.rsp
RUN /opt/ibm/db2/V11.5/instance/db2icrt -s client db2inst1