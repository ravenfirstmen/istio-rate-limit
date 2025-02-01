#!/usr/bin/env bash

source "$(dirname "$(readlink -f "$0")")"/_local_vars.sh

mkdir -p "${DOT_K3D_MANIFESTS_FOLDER}"
mkdir -p "${DOT_K3D_VOLUMES_FOLDER}"

cp ${MANIFESTS_FOLDER}/* "${DOT_K3D_MANIFESTS_FOLDER}"

uuidgen | tr -d '-' > ${DOT_K3D_VOLUMES_FOLDER}/machine-id

export K3D_FIX_MOUNTS=1
export K3D_FIX_DNS=1

if k3d cluster list "${CLUSTER_NAME}" > /dev/null 2>&1; then
    echo "Refreshing cluster...."
	k3d cluster delete "${CLUSTER_NAME}"
fi

k3d cluster create "${CLUSTER_NAME}" \
    --image "rancher/k3s:v1.29.10-k3s1-amd64" \
    --api-port 6443 \
    --registry-create "${REGISTRY}" \
    --port "80:80@loadbalancer" \
    --port "9090:9090@loadbalancer" \
    --port "3000:3000@loadbalancer" \
    --port "3100:3100@loadbalancer" \
    --servers 3 \
    --agents 1 \
    --wait \
    --k3s-arg '--disable=metrics-server@server:*' \
    --volume "${DOT_K3D_MANIFESTS_FOLDER}:/var/lib/rancher/k3s/server/manifests/custom@server:*" \
    --volume "${DOT_K3D_VOLUMES_FOLDER}/machine-id:/etc/machine-id@server:*;agent:*" \
    --k3s-node-label 'node/nodegroup=infra@server:*' \
    --k3s-node-label 'node/nodegroup=worker@agent:*'
