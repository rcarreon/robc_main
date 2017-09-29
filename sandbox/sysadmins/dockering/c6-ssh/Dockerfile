FROM centos:centos6

MAINTAINER Fletcher Davis fletcher.davis@evolvemediallc.com

# update
RUN yum update -y

# get epel
COPY epel.repo /etc/yum.repos.d/
RUN yum install -y epel-release

# setup ansible
COPY playbooks /tmp/playbooks
COPY hosts /etc/ansible/hosts
#COPY inventory /etc/ansible/hosts

RUN yum install -y ansible \
    && ansible-playbook /tmp/playbooks/setup.yml -c local \
    && rm -rf /tmp/*

# need port 22
EXPOSE 22

# startup sshd on boot
CMD /etc/init.d/sshd start && bash
