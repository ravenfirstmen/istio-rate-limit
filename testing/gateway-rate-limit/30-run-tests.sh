#!/usr/bin/env bash

target='http://httpbin.127-0-0-1.nip.io'

#headers
echo "Testing header (10 req/minute) ...."
for i in {1..12}; do
    echo -n "Executing ${i} request ...."
    status_code=$(curl -k --header 'x-should-rate-limit: yes' -s -o /dev/null -I -w "%{http_code}" "${target}/headers" 2>/dev/null)
    echo "status code of response was: ${status_code}."
done


#get path
echo "Testing get path (5 req/minute) ...."
for i in {1..7}; do
    echo -n "Executing ${i} request ...."
    status_code=$(curl -k -s -o /dev/null -I -w "%{http_code}" "${target}/get" 2>/dev/null)
    echo "status code of response was: ${status_code}."
done
