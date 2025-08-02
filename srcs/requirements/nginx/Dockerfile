FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
        -newkey rsa:2048 \
        -out /etc/nginx/ssl/nginx.crt \
        -keyout /etc/nginx/ssl/nginx.key \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=wzeraig.42.fr/UID=wzeraig" && \
    mkdir -p /var/run/nginx

COPY conf/default /etc/nginx/sites-available/wzeraig.42.fr.conf
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/wzeraig.42.fr.conf /etc/nginx/sites-enabled/default

CMD ["nginx", "-g", "daemon off;"]
