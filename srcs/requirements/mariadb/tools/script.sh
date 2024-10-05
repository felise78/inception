#!/bin/sh

set -eux # print commands & exit on error (helps debug)

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

service mariadb start

mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_ROOT_PASSWORD');
EOF

sleep 5

service mariadb stop

exec $@ 

# NOTES
# set -eux : 
#-e : quit the script if something goes wrong
#-x : print each command before its execution
#-u : print an error message if a not set variable is used