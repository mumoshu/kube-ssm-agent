FROM amazonlinux:2

LABEL maintainer "Yusuke Kuoka <ykuoka@gmail.com>"

ENV KUBECTL_VERSION 1.21.2
ENV IAM_AUTHENTICATOR_VERSION 0.5.3

RUN yum update -y && \
    yum install -y systemd curl tar sudo procps && \
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

RUN mkdir work && cd work && \
    curl -L https://dl.k8s.io/v${KUBECTL_VERSION}/kubernetes-client-linux-amd64.tar.gz -o temp.tgz && \
    tar zxvf temp.tgz && \
    mv kubernetes/client/bin/kubectl /usr/bin/kubectl && \
    cd .. && \
    rm -rf work

RUN curl -L https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${IAM_AUTHENTICATOR_VERSION}_linux_amd64 -o /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

#Failed to get D-Bus connection: Operation not permitted
#RUN systemctl status amazon-ssm-agent

WORKDIR /opt/amazon/ssm/
CMD ["amazon-ssm-agent", "start"]
