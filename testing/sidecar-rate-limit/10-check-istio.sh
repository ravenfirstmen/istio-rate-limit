#!/usr/bin/env bash
ns=httpbin
pod=$(kubectl get pods -l app=httpbin --namespace ${ns} -o json | jq -r '.items[].metadata.name' | head -1)

# dump istio gateway config
kubectl exec ${pod} -n ${ns} -c istio-proxy -it -- curl 'http://localhost:15000/config_dump' > config_dump.json

# Verify rate limiter cluster is properly registered
# istioctl proxy-config cluster ${pod}.${ns} -o json > cluster.json

# Check rate limiter filter is attached to the http filter chain
# istioctl proxy-config listener ${pod}.${ns} -o json  > listener.json

# Verify the route configuration
# istioctl proxy-config route ${pod}.${ns} -o json  > route.json
