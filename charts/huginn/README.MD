# What is this?

This is the Funky Penguin Geek Cookbook's Huggin chart

# How do I use it?

Deploy the chart as follows, customizing `myvalues.yaml` file, overriding any of the parameters defined below.

```
cd charts/huginn
cp values.yaml myvalues.yaml # (customize myvalues.yaml as necessary)
kubectl create namespace huginn
helm upgrade --install -f myvalues.yaml -n huginn huggin .
```

# Parameters

| **Parameter**                   | **Description**                                                         | **Default**           |
| ------------------------------- | ----------------------------------------------------------------------- | --------------------- |
| `names.deployment`              | The name of the service                                                 | `huginn`              |
| `names.service`                 | The name of the secret                                                  | `huginn`              |
| `names.secret`                  | The name of the Ingress rule                                            | `huginn`              |
| `names.ingress`                 |                                                                         | `huginn`              |
| `app.replicas`                  | Labels are customizable to how you like.                                | `1`                   |
| `app.labels.app`                | Set the resources you want to allocate to each pod                      | `Huginn`              |
| `app.resources`                 |                                                                         | `{}`                  |
| `app.image.image`               | The Image Pull Policy (The same one if you were writing it yourself!)   | `huginn/huginn`       |
| `app.image.pullPolicy`          |                                                                         | `IfNotPresent`        |
| `app.service.internalPort`      | The name of the port                                                    | `3000`                |
| `app.service.name`              |                                                                         | `http-huginn`         |
| `app.probes.liveness.httpPath`  |                                                                         | `/`                   |
| `app.probes.readiness.httpPath` |                                                                         | `/`                   |
| `ingress.enabled`               | Either `traefik` or `kube`, Defines the type of ingress rule to use     | `True`                |
| `ingress.type`                  | The host you can access this service at                                 | `kube`                |
| `ingress.host`                  | A path you can access it at, It is not recommended to change it off `/` | `huginn.local`        |
| `ingress.path`                  | TLS Settings for Ingress                                                | `/`                   |
| `ingress.tls`                   |                                                                         | `{}`                  |
| `ingress.annotations`           | Annotations for the ingress                                             | `{}`                  |
| `smtp.enable`                   | Mail domain to send from                                                | `True`                |
| `smtp.domain`                   | Email Account Username                                                  | `huginn.local`        |
| `smtp.username`                 | Email Account Password                                                  | `huginn@huginn.local` |
| `smtp.password`                 | Email Server Address                                                    | `hugginwithhuginn`    |
| `smtp.server`                   | Email Server Port                                                       | `mail.local`          |
| `smtp.port`                     | Email Server authenticaiton type                                        | `465`                 |
| `smtp.authentication`           | Email Server use STARTTLS                                               | `plain`               |
| `smtp.starttls`                 | Huginn Invitation Code                                                  | `True`                |
| `invitation_code`               |                                                                         | `HUGMEHUGINN`         |
| `db.deploy`                     | Database Address - Can be external or point to an existing database     | `True`                |
| `db.address`                    |                                                                         | `nil`                 |
| `db.port`                       | Database Port                                                           | `5432`                |
| `db.username`                   | Database Password                                                       | `huginn`              |
| `db.password`                   | Seed the database (fill with dummy data)                                | `huggingwithsql`      |
| `db.seed`                       |                                                                         | `nil`                 |
| `twitter.enabled`               |                                                                         | `True`                |
| `twitter.oauth.key`             | Twitter OAuth2 Secret                                                   | `tweettweet`          |
| `twitter.oauth.secret`          |                                                                         | `twoottweet`          |
| `postgresql.fullnameOverride`   | Set the username here to the same one as in `db.username`               | `huginnsql`           |
| `postgresql.postgresqlUsername` | Set the password here to the same one as in `db.password`               | `huginn`              |
| `postgresql.postgresqlPassword` |                                                                         | `huggingwithsql`      |
| `postgresql.service.port`       |                                                                         | `5432`                |
