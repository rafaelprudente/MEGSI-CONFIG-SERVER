#!/bin/sh

mvn clean package

docker build . -t 192.168.56.101:32000/configuration-server:latest
docker push 192.168.56.101:32000/configuration-server:latest