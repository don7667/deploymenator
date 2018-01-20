#!/bin/bash

REPO="github.com/don7667/docker-node.git"

GIT_BRANCH='mirror'

dir=$(basename "$REPO" ".git")
dir=${PWD}/../${dir}

if [[ -d "$dir" ]]; then
   echo "Folder $dir already exists"
else
   git clone -b $GIT_BRANCH "https://$REPO" $dir
fi
