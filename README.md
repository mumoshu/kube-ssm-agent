# kube-ssm-agent

`kube-ssm-agent` is a set of `Dockerfile` and a Kubernetes manifest file to deploy `aws-ssm-agent` onto Kubernetes nodes.

## Pre-request

You need to attach the `AmazonEC2RoleforSSM` policy to worker nodes instance role.

## Getting started

Clone this repository and run:

```console
$ kubectl apply -f daemonset.yaml

$ AWS_DEFAULT_REGION=us-west-2 aws ssm start-session --target <instance-id>

starting session with SessionId: ...

sh-4.2$ ls
sh-4.2$ pwd
/opt/amazon/ssm
sh-4.2$ bash -i
[ssm-user@ip-192-168-84-111 ssm]$

[ssm-user@ip-192-168-84-111 ssm]$ exit
sh-4.2$ exit

Exiting session with sessionId: ...
```

It worth noting that you should delete the `daemonset` when you don't need node access, so that a malicious user without K8S API access but with SSM sessions manager access
is unable to obtain root access to nodes.

## Rationale

This is an alternative to installing `aws-ssm-agent` binaries directly on nodes, or enabling `ssh` access on nodes.

This approach allows you to run an updated version SSM Agent without a need to install it into a host machine.

`aws-ssm-agent` with AWS SSM Sessions Manager allows you running commands and opening audited interactive terminal sessions to nodes, without maintaining SSH infrastructure.

## Troubleshooting

Q1. start-session fails like this

```console
$ aws ssm start-session --target i-04ffadbaae98a5bd0

An error occurred (TargetNotConnected) when calling the StartSession operation: i-04ffadbaae98a5bd0 is not connected.

SessionManagerPlugin is not found. Please refer to SessionManager Documentation here: http://docs.aws.amazon.com/console/systems-manager/session-manager-plugin-not-found
```
