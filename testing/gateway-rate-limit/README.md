## About

Istio gateway global rate limit


### Steps

Deploy the following manifests

```shell
kubectl apply -f 01-install-ingress-gateway-chart.yaml
kubectl apply -f 02-create-namespace-ingress-gateway.yaml
kubectl apply -f 03-deploy-http-bin.yaml
kubectl apply -f 04-envoy-filters.yaml
kubectl apply -f 05-rate-limit-configs.yaml
```


```shell
# verify istio settings using istioctl
# NOTE: there is a commented alternative to use kubectl if istioctl is not installed
./10-check-istio.sh

# verify the configuration of rate limit service /rlconfig
./20-check-rate-limit.sh

# execute tests 
./30-run-tests.sh

```

Settings
```yaml
---
... (envoy filter)
          rate_limits:
            - actions: 
              - request_headers:
                  header_name: ":path"
                  descriptor_key: "PATH"

            - actions: 
              - request_headers:
                  header_name: "x-should-rate-limit"
                  descriptor_key: "do_rate_limit"
              - request_headers:
                  header_name: ":path"
                  descriptor_key: "PATH"

... (rate limit service)                  
    domain: httpbin-ratelimit

    descriptors:
      - key: do_rate_limit
        value: "yes"
        descriptors:
        - key: PATH
          value: "/headers"
          rate_limit:
            unit: minute
            requests_per_unit: 10
            
      - key: PATH
        value: "/get"
        rate_limit:
          unit: minute
          requests_per_unit: 5
...          
```

the results should be something like

```shell
Testing header (10 req/minute) ....
Executing 1 request ....status code of response was: 200.
Executing 2 request ....status code of response was: 200.
Executing 3 request ....status code of response was: 200.
Executing 4 request ....status code of response was: 200.
Executing 5 request ....status code of response was: 200.
Executing 6 request ....status code of response was: 200.
Executing 7 request ....status code of response was: 200.
Executing 8 request ....status code of response was: 200.
Executing 9 request ....status code of response was: 200.
Executing 10 request ....status code of response was: 200.
Executing 11 request ....status code of response was: 429.
Executing 12 request ....status code of response was: 429.
Testing get path (5 req/minute) ....
Executing 1 request ....status code of response was: 200.
Executing 2 request ....status code of response was: 200.
Executing 3 request ....status code of response was: 200.
Executing 4 request ....status code of response was: 200.
Executing 5 request ....status code of response was: 200.
Executing 6 request ....status code of response was: 429.
Executing 7 request ....status code of response was: 429.
```
