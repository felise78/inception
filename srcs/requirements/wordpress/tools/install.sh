#!/bin/sh
FILE=wordpress
cd /var/www/html

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

if [ -d "$FILE" ]; then
    echo "$FILE exists."
else
    echo "$FILE not exists." 
    mkdir -p wordpress
    cd wordpress
    
    # download the wp-cli.phar file which contains the WP-CLI tool
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    # runs the wp-cli.phar (php Archive)
    php wp-cli.phar --info
    chmod +x wp-cli.phar
    # allows to use the WP-CLI tool just by typing wp
    mv wp-cli.phar /usr/local/bin/wp
    # downloads the Wordpress core (all the necessary Wordpress files)
    # with root permission
    wp core download --allow-root 
    
    sleep 5
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_USER_PASSWORD --dbhost=$DB_HOST --allow-root 
    sleep 5

    wp core install --url=hemottu.42.fr --title=INCEPTION --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root  
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=$WP_USER_ROLE --porcelain --allow-root 
    wp theme install neve --activate --allow-root 
    
    wp config set WP_CACHE true --add --allow-root  
    wp plugin update --all --allow-root  
    echo "END" 
fi

# execute the FastCGI Process Manager
/usr/sbin/php-fpm7.4 -F

# NOTES 
# FastCGI is a protocole that allows communication between a web server and
# an application written in PHP (or Python or Ruby). It handles the requests