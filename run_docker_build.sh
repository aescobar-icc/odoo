#!/bin/bash
source ./run_base.sh
source ./run_version.sh
if [ "$*" == "--publish" ];then
	code-version -s
else
	code-version
fi

IMAGE_REPO="aescobaricc"
export CODE_VERSION
export IMAGE_NAME="$IMAGE_REPO/odoo_app"

log "Building $IMAGE_NAME:$CODE_VERSION"

docker-compose --file ./docker-compose-build.yaml build

if [ "$*" == "--publish" ];then
	docker image push "$IMAGE_NAME:$CODE_VERSION"
fi