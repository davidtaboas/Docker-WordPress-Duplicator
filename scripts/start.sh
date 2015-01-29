#!/bin/bash
shell_out=0
if [ ! -f /var/www/wp-config.php ]; then
#mysql has to be started this way as it doesn't work to call from /etc/init.d
echo Copying files duplicator...
sleep 5
rm -rf /var/www
cp -R /wp-install /var/www
chown -R www-data:www-data /var/www/

/usr/bin/mysqld_safe &
sleep 10s
#This is so the passwords show up in logs.
started_mysql=1
WORDPRESS_DB="wordpress"
ROOT_DB_PASSWORD=`pwgen -c -n -1 12`
WP_DB_PASSWORD=`pwgen -c -n -1 12`
#This is so the passwords show up in logs.
echo MySQL root password: $ROOT_DB_PASSWORD
echo MySQL wordpress password: $WP_DB_PASSWORD
echo $ROOT_DB_PASSWORD > /root-db-pw.txt
echo $WP_DB_PASSWORD > /wordpress-db-pw.txt
mysqladmin -u root password $ROOT_DB_PASSWORD
mysql -uroot -p$ROOT_DB_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WP_DB_PASSWORD'; FLUSH PRIVILEGES;"



sleep 3s
echo Auto-Install WordPress
cd /var/www
cat /auto.installer.with.shim.php installer.php > installer.with.shim.php
php installer.with.shim.php localhost wordpress $WP_DB_PASSWORD wordpress *.zip
echo Syncing WordPress
ln -s /var/www/wp-content /wordpress/wp-content


fi


if [ "$started_mysql" == "1" ]; then
  echo Stopping MySQL...will restart via supervisord momentarily
  killall mysqld
fi

echo Starting the services
if [ "$shell_out" == "1" ]; then
  /usr/local/bin/supervisord -c /etc/supervisord.conf
  /bin/bash
else
  /usr/local/bin/supervisord -n -c /etc/supervisord.conf
fi