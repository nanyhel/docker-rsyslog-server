FROM ubuntu:20.04

RUN apt update && apt install rsyslog -y

RUN echo '$ModLoad imudp \n\
$UDPServerRun 514 \n\
$ModLoad imtcp \n\
$InputTCPServerRun 514 \n\
$template RemoteStore, "/var/log/remote/%HOSTNAME%/%$year%%$Month%%$Day%.log" \n\
:source, !isequal, "localhost" -?RemoteStore \n\
:source, isequal, "last" ~ ' > /etc/rsyslog.conf

ENTRYPOINT ["rsyslogd", "-n"]
