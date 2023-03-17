FROM centos:centos8
# Fix centos8 "No URLs in mirrorlist" error
RUN sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-*
RUN sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-*

# Add Oracle yum repo
RUN yum install -y wget
RUN wget https://yum.oracle.com/RPM-GPG-KEY-oracle-ol8 -O /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
RUN gpg --import --import-options show-only /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
COPY resources/oracle-public-yum-ol8.repo /etc/yum.repos.d/oracle-public-yum-ol8.repo

# Install Oracle Instant client
RUN yum install -y oracle-instantclient-release-el8
RUN yum install -y oracle-instantclient-sqlplus.x86_64