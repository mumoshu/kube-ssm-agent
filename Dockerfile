FROM amazonlinux:2

LABEL maintainer "Yusuke Kuoka <ykuoka@gmail.com>"

RUN yum update -y && \
    yum install -y systemd && \
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

#Failed to get D-Bus connection: Operation not permitted
#RUN systemctl status amazon-ssm-agent

WORKDIR /opt/amazon/ssm/
CMD ["amazon-ssm-agent", "start"]
