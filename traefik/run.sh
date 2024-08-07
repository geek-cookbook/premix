#!/bin/bash

# Create traefik overlay network
docker network create --driver=overlay --subnet=10.1.0.0/24 traefik

#    --mode global \
# Create swarm service 
docker service create \
    --name traefik \
    --constraint=node.role==manager \
    --mode global \
    --publish mode=host,target=80,published=80 \
    --publish mode=host,target=443,published=443 \
    --publish 8080:8080 \
    --label "traefik.frontend.rule=Host:traefik.funkypenguin.co.nz" \
    --label "traefik.port=8080 "\
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,readonly=true \
    --mount type=bind,source=/var/data/traefik/traefik.toml,target=/traefik.toml,readonly=true \
    --mount type=bind,source=/var/data/traefik/acme.json,target=/acme.json \
    --network traefik \
    traefik:v1.3.3-alpine --web --docker --docker.swarmmode --docker.watch --docker.domain=funkypenguin.co.nz
    
