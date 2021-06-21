#!/bin/bash

cd `dirname $0`
cd ..

docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i http://gateway.docker.internal:8000/openapi.json \
    -g swift5 \
    -o /local/ImportSDKDemo/ \
    --additional-properties=responseAs=Combine \
    --additional-properties=projectName=AggregateAPIClient \
    --ignore-file-override /local/ImportSDKDemo/.openapi-generator-ignore

rm -rf ImportSDKDemo/docs
rm -rf ImportSDKDemo/.openapi-generator

