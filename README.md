Docker Rsyslog Server
---

### Construir imagen.

```
$ docker build -t docker-syslog .
```

### Correr contedor.

```
$ docker run --cap-add SYSLOG -p 514:514 -p 514:514/udp --name rsyslog docker-syslog
```

### Referencia.

* Dockerize Rsyslog Server [enlace.](https://itnext.io/dockerize-rsyslog-server-f8f9754c37d5)