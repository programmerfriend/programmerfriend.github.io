#!/usr/bin/env bash

docker run -it --rm -v "$PWD":/usr/src/app --publish 127.0.0.1:3000:4000 starefossen/github-pages