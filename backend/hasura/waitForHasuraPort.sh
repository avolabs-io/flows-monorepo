#!/bin/bash

echo "Waiting Hasura to launch on 8080..."

while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8080/v1/version)" != "200" ]]; do sleep 1; done

echo "Hasura launched"
