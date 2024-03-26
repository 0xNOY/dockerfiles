#!/bin/bash

function yesno {
    # default: no
    read -p "$1 [y/N] " -n 1 -r
    echo
}

NAMESPACE="0xnoy"
ROOT=$(dirname $(realpath $0))

TARGET=$(realpath $1)
if [ ! -d "$TARGET" ]; then
    TARGET=$(dirname "$TARGET")
fi

cd "$ROOT"
TARGET=$(realpath --relative-to="$ROOT" "$TARGET")

OLDIFS=$IFS

IFS="/" DIRS=( $TARGET )
TAG="${NAMESPACE}/${DIRS[0]}:"
unset DIRS[0]
IFS="-" TAG+=$(echo "${DIRS[*]}")

IFS=$OLDIFS

docker build -t $TAG $TARGET
echo Built $TAG

yesno "Push to Docker Hub?"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker push $TAG
    echo Pushed $TAG
fi
