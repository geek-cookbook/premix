# What is this?

This is the set of files used for Funky Penguin's Turtlecoin (TRTL) mining pool, at https://trtl.heigh-ho.funkypenguin.co.nz

# How do I use it?

## Requirements

You must already have a cluster setup, a load balancer as explained at https://geek-cookbook.funkypenguin.co.nz/kubernetes/loadbalancer/, and a Traefik ingress, as explained at https://geek-cookbook.funkypenguin.co.nz/kubernetes/traefik/

## Setup

Create the namespace:

```
kubectl create -f namespace.yml
```

Then create the persistent volume claims:

```
kubectl create -f daemon-persistent-volumeclaim.yml
kubectl create -f pool-persistent-volumeclaim.yml
kubectl create -f redis-persistent-volumeclaim.yml
kubectl create -f wallet-persistent-volumeclaim.yml
```

Then create the configmaps (after editing to insert appropriate values):

```
cp wallet.conf-example wallet.conf
kubectl create configmap -n trtl wallet-conf --from-file=wallet.conf

cp trtl.json-example trtl.json
kubectl create configmap -n trtl pool-config --from-file=trtl.json

kubectl create configmap -n trtl pool-email-txt --from-file=email.txt

kubectl create configmap -n trtl redis-config --from-file=redis.conf
```

Then create secret necessary to use the webhook:

```
cp webhook_token.secret-example webhook_token.secret
kubectl create secret -n trtl generic trtl-credentials \
   --from-file=webhook_token.secret
```

Create the necessary pods and services, customising the environment in each one to suit your deployment:

```
kubectl create -f redis.yml
kubectl create -f wallet.yml
kubectl create -f daemon.yml
kubectl create -f pool.yml
kubectl create -f pool-service.yml
```

Create the NodePort services used by your pool:

```
kubectl create -f pool-service-nodeport.yml
```

Create the ingress (used by traefik) for your pool and API:

```
kubectl create -f pool-ingress.yml
```

When complete, your pods, services, and ingresses should look like this:

```
[funkypenguin:~] 1 % kubectl get pods -n trtl
NAME                      READY     STATUS             RESTARTS   AGE
daemon-675dcbb5b5-vk6hs   1/1       Running            0          23d
pool-566fdd57c-m8lht      5/5       Running            0          26d
redis-7df4f65f5-dr7rs     1/1       Running            0          31d
wallet-bd4b5977b-q8spv    1/1       Running            0          31d
[funkypenguin:~] %
[funkypenguin:~] % kubectl get services -n trtl
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                        AGE
daemon                 ClusterIP   None            <none>        11898/TCP                                      113d
pool-mining-nodeport   NodePort    10.59.254.187   <none>        3333:30333/TCP,5555:30555/TCP,7777:30777/TCP   112d
pool-ui                ClusterIP   10.59.241.6     <none>        80/TCP,8117/TCP                                167d
redis                  ClusterIP   None            <none>        6379/TCP                                       167d
wallet                 ClusterIP   None            <none>        8070/TCP                                       166d
[funkypenguin:~] %
[funkypenguin:~] % kubectl get ingress -n trtl
NAME        HOSTS                                                                   ADDRESS   PORTS     AGE
trtl-pool   trtl.heigh-ho.funkypenguin.co.nz,api.trtl.heigh-ho.funkypenguin.co.nz             80        167d
[funkypenguin:~] %
```
