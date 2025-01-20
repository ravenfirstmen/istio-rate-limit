#!/usr/bin/env bash

rl_pod=$(kubectl get pods -l app.kubernetes.io/name=ratelimit --namespace rate-limit -o json | jq -r '.items[].metadata.name' | head -1)

# dump rate limit config
echo "==== CONFIG ===="
kubectl exec ${rl_pod} -n rate-limit -it -- wget 0:6070/rlconfig -q -O-
# echo "==== STATS ===="
# kubectl exec ${rl_pod} -n rate-limit -it -- wget 0:6070/stats -q -O-
# header x-a-header: a_http_header
