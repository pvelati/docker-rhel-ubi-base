FROM registry.access.redhat.com/ubi8/ubi
LABEL maintainer="Paolo Velati"

# Fix dnf message
RUN sed -i -r 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf

# Install EPEL repo
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Update sources and upgrade packages
RUN dnf -y update 

# Install packages
RUN dnf install -y epel-release \
       less nano vim zip unzip \
       sudo systemd curl systemd-sysv \
       gcc gcc-c++ make \
       wget libffi-devel openssl-devel \
       python3-pip python3-devel python3-setuptools python3-wheel

# Clean system
RUN rm -rf /usr/share/doc /usr/share/man /tmp/* /var/tmp/* 

# Set default apps
RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 

# Fix python3 as default
RUN ln -s /usr/bin/python3 /usr/bin/python

# Prepare host for ansible 
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Make sure systemd doesn't start agettys on tty[1-6]
RUN rm -f /lib/systemd/system/multi-user.target.wants/getty.target

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
