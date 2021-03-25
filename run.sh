#!/bin/bash

docker run  -d \
	--publish 80:8080 \
	--restart always \
	--volume ~/docker/magic_mirror/config:/opt/magic_mirror/config \
	--volume ~/docker/magic_mirror/modules:/opt/magic_mirror/modules \
	--volume /etc/localtime:/etc/localtime:ro \
	--name magic_mirror \
    bastilimbach/docker-magicmirror
