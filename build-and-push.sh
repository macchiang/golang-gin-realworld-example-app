#!/bin/bash
docker build . -t golang-gin:latest
docker push gcr.io/my-gcp-221201/golang-gin:latest
