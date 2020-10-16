# Bean Cafe Project

> Demo Project by Hongrok Lim As airman
from ROKAF CKIS *(Cyber Knowledge Information Space)*

## Envorinment Configuration

### NGINX

OS : Ubuntu

#### 1. install and start nginx

```bash
# install nginx
$ sudo apt-get update
$ sudo apt-get install nginx

# start nginx
$ sudo service nginx start
```

#### 2. configuration nginx and restart

```bash
$ sudo vim /etc/nginx/conf.d/default.d
```

```
server {
    listen 172.25.10.99:80;
    server_name 172.25.10.99;

    # pgadmin4
    location /pgadmin4/ {
        proxy_set_header X-Script-Name /pgadmin4;
        proxy_set_header Host          $host;

        proxy_pass http://127.0.0.1:5433/;
        proxy_redirect off;
    }

    # code-server
    location /code-server/ {
        proxy_set_header X-Script-Name /code-server;
        proxy_set_header Host          $host;

        # web socket conf
        proxy_set_header Upgrade       $http_upgrade;
        proxy_set_header Connection    "Upgrade";

        proxy_pass http://127.0.0.1:8081/;
        proxy_redirect off;
        proxy_http_version 1.1;
    }

    # wildfly
    location /wildfly/ {
        proxy_set_header X-Script-Name /wildfly;
        proxy_set_header Host          $host;

        proxy_pass http://127.0.0.1:8082/;
        proxy_redirect off;
    }
```

```bash
$ sudo service nginx restart
```

### mount privilege

``` bash
# pgadmin4
$ sudo chgrp -R 5050 ~/bean-cafe-project/pga-data
$ sudo chmod -R 775 ~/bean-cafe-project/pga-data

# maven repository
$ sudo chown -R hongrr123 /root/.m2/repository
```

### volume privilege

```bash
# wildfly deployment (in code-server)
$ sudo chown coder ~/wildfly/standalone/deployments/*
```
