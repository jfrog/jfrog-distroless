#!/bin/bash

curl -fL https://getcli.jfrog.io | sh
docker --version

curl https://get.docker.com | bash
service docker start

docker info
