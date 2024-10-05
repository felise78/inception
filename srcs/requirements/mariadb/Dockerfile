FROM debian:bullseye

EXPOSE 3306

RUN apt-get update && apt-get install -y mariadb-server \
    mariadb-client

# copy files into the container
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /

# give permission to execute the script
RUN  chmod +x /script.sh

ENTRYPOINT [ "/script.sh", "mysqld_safe"]