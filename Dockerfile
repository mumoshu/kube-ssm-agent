FROM amazonlinux:2

RUN yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /opt/amazon/ssm/
CMD ["/entrypoint.sh"]
