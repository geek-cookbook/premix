# What is this?

# How do I use it?

First off, if you're going to use certmanager, install the necessary CRDs by running

```
kubectl apply --validate=false \
    -f https://raw.githubusercontent.com/jetstack/certmanager/release-0.13/deploy/manifests/00-crds.yaml
```

The output should look like this:

```
kubectl apply --validate=false \
    -f https://raw.githubusercontent.com/jetstack/certmanager/release-0.13/deploy/manifests/00-crds.yaml
customresourcedefinition.apiextensions.k8s.io/certificaterequests.certmanager.io created
customresourcedefinition.apiextensions.k8s.io/certificates.certmanager.io created
customresourcedefinition.apiextensions.k8s.io/challenges.acme.certmanager.io created
customresourcedefinition.apiextensions.k8s.io/clusterissuers.certmanager.io created
customresourcedefinition.apiextensions.k8s.io/issuers.certmanager.io created
customresourcedefinition.apiextensions.k8s.io/orders.acme.certmanager.io created
```

The simlpest way is, from the root of the repo, to run `helm upgrade --install -n wash-hands wash-hands wash-hands/helm-chart/wash-hands`

