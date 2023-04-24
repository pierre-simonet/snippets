# This Dockerfile allows to use system
# Tested successfully with Centos 8, Centos Stream 8

# /!\/!\/!\ THIS IS NOT WORKING WITH Centos 7 /!\/!\/!\

# FROM quay.io/centos/centos:stream8
FROM centos:8


RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

ENTRYPOINT /usr/sbin/init