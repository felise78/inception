FROM debian:bullseye

# install nginx and the tool for ssl certificate
RUN apt-get update -y && \
    apt-get install -y nginx \
    openssl && \
    # create a directory to store the ssl certificate infos
    mkdir -p /etc/nginx/ssl && \
    # generate the SSL certificate
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=hemottu.42.fr/UID=hemottu"

# create a dir and copy the configuration file into it
RUN mkdir -p /var/run/nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# ensure that the website dir is accessible and belongs to the www-data user (nginx user)
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]