FROM alpine:3.19

# Instalar rsyslog y dependencias necesarias
RUN apk add --no-cache rsyslog tzdata

# Crear directorio para logs remotos
RUN mkdir -p /var/log/remote

# Configurar rsyslog para recibir logs remotos
RUN echo '$ModLoad imudp' > /etc/rsyslog.conf && \
    echo '$UDPServerRun 514' >> /etc/rsyslog.conf && \
    echo '$ModLoad imtcp' >> /etc/rsyslog.conf && \
    echo '$InputTCPServerRun 514' >> /etc/rsyslog.conf && \
    echo '$template RemoteStore, "/var/log/remote/%HOSTNAME%/%$year%%$month%%$day%.log"' >> /etc/rsyslog.conf && \
    echo ':source, !isequal, "localhost" -?RemoteStore' >> /etc/rsyslog.conf && \
    echo ':source, isequal, "last" ~' >> /etc/rsyslog.conf

# Exponer puertos para UDP y TCP
EXPOSE 514/udp 514/tcp

# Agregar health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD netstat -ln | grep :514 || exit 1

# Ejecutar rsyslog en foreground
ENTRYPOINT ["rsyslogd", "-n"]
