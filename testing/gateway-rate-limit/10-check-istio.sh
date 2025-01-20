#!/usr/bin/env bash
ns=httpbin
gateway=$(kubectl get pods -l app=istio-ingress --namespace ${ns} -o json | jq -r '.items[].metadata.name')

# dump istio gateway config
# kubectl exec ${gateway} -n ${ns} -it -- curl 'http://localhost:15000/config_dump' > config_dump.json

# Verify rate limiter cluster is properly registered
istioctl proxy-config cluster ${gateway}.${ns} -o json

# check rate limiter filter is attached to the http filter chain
istioctl proxy-config listener ${gateway}.${ns} -o json

# Verify the route configuration
istioctl proxy-config route ${gateway}.${ns} -o json
