#!/usr/bin/env bash
#
#  Author		: Wilton Guilherme
#  Manteiner 	: CodeView Consultoria
#
#  Kube DevOps CI Tools
#  Copyright Β© 2021 CodeView Consultoria, All Rights Reserved
#

set -o errexit
CA=$CA
SERVER=$SERVER
CONTEXT=$CONTEXT
CLUSTER=$CLUSTER
NAMESPACE=$NAMESPACE
USERNAME=$USERNAME
TOKEN=$TOKEN
AWS_REGION=$AWS_REGION
AWS_ACCESS_KEY=$AWS_ACCESS_KEY
AWS_SECRET_KEY=$AWS_SECRET_KEY
CLUSTER_NAME=$CLUSTER_NAME
KOPS_STATE_STORE=$KOPS_STATE_STORE

verify_files () {
    if [ ! -d /root/.kube ]
    then mkdir -p /root/.kube/
    fi
    if [ ! -d /root/.aws ]
    then mkdir -p /root/.aws
    fi
}

kube_config () {
    sed -e "s;%CA%;$CA;g" -e "s;%SERVER%;$SERVER;g" \
    -e "s;%CONTEXT%;$CONTEXT;g" -e "s;%CLUSTER%;$CLUSTER;g" \
    -e "s;%NAMESPACE%;$NAMESPACE;g" -e "s;%USERNAME%;$USERNAME;g" \
    -e "s;%TOKEN%;$TOKEN;g" /srv/kube-config.tmpl > /root/.kube/config
}

aws_config () {
    sed -e "s;%AWS_REGION%;$AWS_REGION;g" /srv/aws-config.tmpl > /root/.aws/config
    sed -e "s;%AWS_ACCESS_KEY%;$AWS_ACCESS_KEY;g" -e "s;%AWS_SECRET_KEY%;$AWS_SECRET_KEY;g" /srv/aws-credentials.tmpl > /root/.aws/credentials
}

echo "π§ Checking if auth files exist" >&2 
verify_files
echo "π³ Configure kubeconfig auth βΈοΈ" >&2
kube_config
echo "π Configure awscli auth " >&2
aws_config
echo "π Authentication configured π" >&2