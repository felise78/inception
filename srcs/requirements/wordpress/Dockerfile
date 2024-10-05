FROM debian:bullseye

EXPOSE 9000

# install wordpress and php and the dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install \
    unzip php curl wget \
    php-mysqli php-fpm php-cgi php-curl php-gd php-mbstring \
    php-xml php-xmlrpc php-soap php-intl php-zip \
    default-mysql-client -y && \
    # create a dir for php 
    mkdir /run/php

# copy the conf file
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# copy the script file
COPY ./tools/install.sh /home/

# give permission to run the script
RUN chmod 777 /home/install.sh

ENTRYPOINT ["/home/install.sh" ] 