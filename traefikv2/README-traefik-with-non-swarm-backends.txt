#Configure Traefik to connect to a not-docker-container-service.

Sometimes we want Traefik to proxy the request of a FQDN to a inner service that is not running inside a docker container / swarm.
As docker swarm doesn’t allow (at this moment) to access to the devices of the host machine, if you want to deploy a service that needs to access an USB stick (for example) you need to run it directly on the host. However they are some proposals to allow swarm to access the devices: https://github.com/docker/swarmkit/issues/2682

##Using Traefik.toml

So in order to configure Traefik to redirect to a non docker service we need to enable the file section on the .toml
For example if we want to add a new service “IPP” that is being exposed on the 192.168.1.4:4679 of our local network, and make it through the FQDN ipp.example.com

```
[file]
watch=true
[frontends]
  [frontends.ipp]
  backend = "ipp"
  pastHostHeader = true
    [frontends.ipp.routes.1]
    rule = "Host:ipp.example.com"


[backends]
  [backends.ipp]
    [backends.ipp.servers.ipp1]
    url = "http://192.168.1.4:4679" #local address of the service
```

##Using oauth2 proxy

However if the service is going to be hiding behind an oauht2 proxy there is another way without having to change the traefik toml.
Create a new swarm stack and add just the oauth2 proxy as service. For the previous example, create a /var/data/config/ipp.yml with the following configuration:

```
version: "3.2"

services:
  proxy:
    image: funkypenguin/oauth2_proxy
    env_file: /var/data/config/ipp/ipp.env
    networks:
      - traefik_public
    volumes:
      - /etc/localtime:/etc/localtime:ro
    deploy:
      labels:
        - traefik.frontend.rule=Host:ipp.example.com
        - traefik.docker.network=traefik_public
        - traefik.port=4180

    volumes:
      - /var/data/config/eaton-ipp/authenticated-emails.txt:/authenticated-emails.txt
    command: |
      -cookie-secure=false
      -upstream=http://192.168.1.4:4679
      -redirect-url=https://ipp.example.com
      -http-address=http://0.0.0.0:4180
      -email-domain=gmail.com
      -provider=github
      -authenticated-emails-file=/authenticated-emails.txt

networks:
  traefik_public:
    external: true
```

And as always deploy the stack:

```
docker stack deploy ipp -c /var/data/config/ipp.yml
```

This proxy would directly redirect to the inner service exposing the FQDN ipp.example.com to the outside.
