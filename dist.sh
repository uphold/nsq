#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
version=$(awk '/const Binary/ {print $NF}' < "$DIR"/internal/version/binary.go | sed 's/"//g')

docker buildx create --use
docker buildx build --platform=linux/arm64,linux/x86_64 -t nsqio/nsq:v"$version" .
if [[ ! $version == *"-"* ]]; then
    echo Tagging nsqio/nsq:v"$version" as the latest release.
    docker tag nsqio/nsq:v"$version" nsqio/nsq:latest
fi
