# kube-ssm-agent

`kube-ssm-agent` is a set of `Dockerfile` and a Kubernetes manifest file to deploy `aws-ssm-agent` onto Kubernetes nodes.

## Getting started

Clone this repository and run:

```console
$ eksctl create cluster

# Replace the role-name with the InstanceRole shown in `eksctl utils describe-stack`
$ aws iam attach-role-policy --role-name eksctl-amazing-creature-154580785-NodeInstanceRole-RXNVQC8YTLP7 --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM

$ kubectl apply -f daemonset.yaml

$ AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target i-04ffadbaae98a5bd0

tarting session with SessionId: mumoshu@example.com-02742d388e6749665

sh-4.2$ ls
sh-4.2$ pwd
/opt/amazon/ssm
sh-4.2$ bash -i
[ssm-user@ip-192-168-84-111 ssm]$

[ssm-user@ip-192-168-84-111 ssm]$ exit
sh-4.2$ exit


Exiting session with sessionId: mumoshu@example.com-02742d388e6749665.
```

It worth noting that you should delete the daemonset when you don't need node access, so that a malicious user without K8S API access but with SSM sessions manager access
is unable to obtain root access to nodes.

## Rationale

The initial motivation was to deploy aws-ssm-agent onto EKS nodes provisioned by `eksctl`. It should have no actual dependency to `eksctl`, so please try and report any issues if it didn't work properly on your other flavor of Kubernetes on AWS.

This is an alternative to installing aws-ssm-agent binaries directly on nodes, or enabling ssh access on nodes.

aws-ssm-agent with AWS SSM Sessions Manager allows you to opening audited interactive terminal sessions to nodes, without maintaining SSH infrastructure.

## FAQ

Q1. start-session fails like this

```console
$ aws ssm start-session --target i-04ffadbaae98a5bd0

An error occurred (TargetNotConnected) when calling the StartSession operation: i-04ffadbaae98a5bd0 is not connected.
kuoka-yusuke-3:kube-ssm-agent kuoka-yusuke$ AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target i-04ffadbaae98a5bd0

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found
```

A1. Install the plugin according to the guidance

https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html

For macOS, try something like the below:

```console
$ curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2457k  100 2457k    0     0   243k      0  0:00:10  0:00:10 --:--:--  306k

$ unzip sessionmanager-bundle.zip
Archive:  sessionmanager-bundle.zip
   creating: sessionmanager-bundle/
   creating: sessionmanager-bundle/bin/
  inflating: sessionmanager-bundle/VERSION
  inflating: sessionmanager-bundle/LICENSE
  inflating: sessionmanager-bundle/seelog.xml.template
  inflating: sessionmanager-bundle/install
  inflating: sessionmanager-bundle/bin/session-manager-plugin

$ sudo ./sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin
Password:
Creating install directories: /usr/local/sessionmanagerplugin/bin
Creating Symlink from /usr/local/sessionmanagerplugin/bin/session-manager-plugin to /usr/local/bin/session-manager-plugin
Installation successful!
```

Q2. CloudFormation stacks created by eksctl fails after enabling kube-ssm-agent

A2. You should have attached the `AmazonEC2RoleforSSM` policy to the instance role managed by eksctl. CloudFormation stack deletion fail because an IAM role with one or more policies attached can't be removed.

The fix would be to deattach the policy from the role, and then rerunning `eksctl delete cluster` or retrigger a stack deletion from AWS Console or awscli.
