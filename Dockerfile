FROM registry.access.redhat.com/ubi7/ubi
LABEL maintainer="Paolo Velati"

# Fix yum message
RUN sed -i -r 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf

# Install EPEL repo
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Update sources and upgrade packages
RUN yum -y update 

# Install packages
RUN yum install -y epel-release \
       less nano vim zip unzip \
       sudo systemd curl systemd-sysv \
       gcc gcc-c++ kernel-devel make \
       wget libffi-devel openssl-devel \
       python34-pip python34-devel \
       python34-setuptools 

# Clean system
RUN rm -rf /usr/share/doc /usr/share/man /tmp/* /var/tmp/* 

# Set default apps
RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3.4 1

# Prepare host for ansible 
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd doesn't start agettys on tty[1-6]
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
