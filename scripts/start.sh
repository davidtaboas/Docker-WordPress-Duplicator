#!/bin/bash
shell_out=0
if [ ! -f /wordpress/wp-config.php ]; then
#mysql has to be started this way as it doesn't work to call from /etc/init.d
echo Copying files duplicator...
sleep 5

rm -rf /var/www
mkdir /var/www
cp -R /wp-install/* /var/www
chown -R www-data:www-data /var/www
chmod 777 /var/www
chmod 644 /var/www/*

/usr/bin/mysqld_safe &
sleep 10s
#This is so the passwords show up in logs.
started_mysql=1
WORDPRESS_DB="wordpress"
ROOT_DB_PASSWORD=`pwgen -c -n -1 12`
WP_DB_PASSWORD=`pwgen -c -n -1 12`
#This is so the passwords show up in logs.
echo ""
echo MySQL root password: $ROOT_DB_PASSWORD
echo MySQL wordpress password: $WP_DB_PASSWORD
echo $ROOT_DB_PASSWORD > /root-db-pw.txt
echo $WP_DB_PASSWORD > /wordpress-db-pw.txt
echo ""
mysqladmin -u root password $ROOT_DB_PASSWORD
mysql -uroot -p$ROOT_DB_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD'; FLUSH PRIVILEGES;"


# TODO Automatizar recogida de datos
# sleep 3s
# echo Auto-Install WordPress
# cd /var/www
# echo "<?php" > auto.installer.php
# echo "\$_POST['dbhost']       = 'localhost';" >> auto.installer.php
# echo "\$_POST['dbuser']       = 'wordpress';" >> auto.installer.php
# echo "\$_POST['dbpass']       = $WP_DB_PASSWORD;" >> auto.installer.php
# echo "\$_POST['dbname']       = 'wordpress';" >> auto.installer.php
# echo "\$_POST['package_name'] = '*.zip';" >> auto.installer.php
# echo "?>" >> auto.installer.php

# cat auto.installer.php installer.php > installer-complete.php
# php installer.with.shim.php localhost wordpress $WP_DB_PASSWORD wordpress *.zip



fi


if [ "$started_mysql" == "1" ]; then
  echo Stopping MySQL...will restart via supervisord momentarily
  killall mysqld
fi

echo Starting the services
if [ "$shell_out" == "1" ]; then
  supervisord -c /etc/supervisord.conf
  /bin/bash
else
  supervisord -n -c /etc/supervisord.conf
fi