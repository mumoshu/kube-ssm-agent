# kube-ssm-agent

`kube-ssm-agent` is a set of `Dockerfile` and a Kubernetes manifest file to deploy `aws-ssm-agent` onto Kubernetes nodes.

## Getting started

Clone this repository and run:

```console
$ kubectl apply -f daemonset.yaml
```

It worth noting that you should delete the daemonset when you don't need node access, so that a malicious user without K8S API access but with SSM sessions manager access
is unable to obtain root access to nodes.

## Rationale

The initial motivation was to deploy aws-ssm-agent for EKS nodegroups provisioned by `eksctl`.

This is an alternative to installing aws-ssm-agent binaryes directly on nodes, or enabling ssh acecss on nodes.

aws-ssm-agent with AWS SSM Sessions Manager allows you to opening audited interactive terminal sessions to nodes, without maintaining SSH infrastructure.
