FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server curl && \
    rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

COPY conf/50-server.conf /etc/mysql/mariadb.conf.d/

ENTRYPOINT ["/usr/local/bin/init.sh"]
