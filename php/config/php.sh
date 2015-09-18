#!/bin/bash

# Set bitbucket Credentials
echo -e "machine bitbucket.org\n login $BITBUCKET_LOGIN\npassword $BITBUCKET_PASSWORD\nmachine github.com\n login $GITHUB_LOGIN\npassword $GITHUB_PASSWORD\n" > ~/.netrc

# Create our Directories structure
if [ ! -d "/$PROJECT_NAME" ];
then
	mkdir /$PROJECT_NAME
fi
rm -rf /$PROJECT_NAME/*	

# Wait until the mysql container is up and ready
while [ "$(mysql -h $DB_PORT_3306_TCP_ADDR -u $MYSQL_USER -p$MYSQL_PASSWORD -e 'select 1')" == '' ]
do
        echo 'Waiting for MySql...'
        sleep 1
done
echo 'MySql is running...'

# Download a new version of WordPress
wp core download --path=/$PROJECT_NAME --version=$WP_VERSION --allow-root

# Configure WordPress
wp core config  --path=/$PROJECT_NAME --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$DB_PORT_3306_TCP_ADDR --allow-root --extra-php <<PHP
define( 'WP_DEBUG', false );
define( 'SAVE_QUERIES', false );
define( 'WP_DEBUG_LOG', false );
define( 'FS_METHOD', 'direct' );
PHP

# Install WordPress
wp core install  --path=/$PROJECT_NAME --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_USERNAME --admin_password=$WP_PASSWORD --admin_email=$WP_EMAIL --allow-root

# Enable Smart Permalinks
wp rewrite structure '/%postname%' --path=/$PROJECT_NAME --allow-root

# Remove Default WordPress Plugins
wp plugin delete hello --path=/$PROJECT_NAME --allow-root
wp plugin delete akismet --path=/$PROJECT_NAME --allow-root

# Install dependency Plugins
array=(${WP_PLUGINS//|/ })
for i in "${!array[@]}"
do
	wp plugin install ${array[i]} --path=/$PROJECT_NAME --allow-root
done

# Install dependency Themes
array=(${WP_THEMES//|/ })
for i in "${!array[@]}"
do
	wp theme install ${array[i]} --path=/$PROJECT_NAME --allow-root
done

# Install development Plugins
array=(${WP_DEV_PLUGINS//|/ })
for i in "${!array[@]}"
do
	s=${array[i]}
	[[ $s =~ ^.*/(.*)\.git$ ]]
	plugin=${BASH_REMATCH[1]}

	git clone ${array[i]} /$PROJECT_NAME/wp-content/plugins/$plugin  
done

# Install development Themes
array=(${WP_DEV_THEMES//|/ })
for i in "${!array[@]}"
do
	s=${array[i]}
	[[ $s =~ ^.*/(.*)\.git$ ]]
	theme=${BASH_REMATCH[1]}

	git clone ${array[i]} /$PROJECT_NAME/wp-content/themes/$theme
done

php-fpm
