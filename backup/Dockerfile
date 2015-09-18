FROM ubuntu 

LABEL version="1.0"

RUN apt-get update
RUN apt-get install mysql-client wget make gcc libssl-dev zlib1g-dev e2fslibs-dev -y

WORKDIR "/root/"
RUN wget --no-check-certificate https://www.tarsnap.com/download/tarsnap-autoconf-1.0.35.tgz
RUN tar -xf tarsnap-autoconf-1.0.35.tgz
WORKDIR "/root/tarsnap-autoconf-1.0.35"
RUN ./configure
RUN make all install clean
RUN mv /usr/local/etc/tarsnap.conf.sample /usr/local/etc/tarsnap.conf
COPY keys/tarsnap.key /root/tarsnap.key

RUN mkdir /backups

ENV BACKUP_TIME 0 3 * * *

COPY backup /bin/
RUN chmod +x /bin/backup
COPY restore /bin/
RUN chmod +x /bin/restore

CMD [ "tail", "-f", "/var/log/lastlog" ]
