FROM php:5.6-fpm

LABEL version="1.0"

#
# Install Useful Tools 
#
RUN apt-get update -y && \
	apt-get install -y mysql-client && \
	apt-get install -y git wget vim
RUN apt-get install -y libmcrypt-dev  libzip-dev

#
# install the PHP extensions we need
#
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mysqli

# Use Custom PHP.ini configuration
COPY config/php.ini /usr/local/etc/php/

#
# Install the WP-CLI
#
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

#
# Install Composer
#
RUN curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer
CMD ["export PATH=/root/.composer/vendor/bin:$PATH"] # Add Composer Binary to PATH

RUN composer global config github-oauth.github.com {{your-github-token}} # Github Token (Required for Composer Packages)

#
# Entrypoint Script
#
COPY config/php.sh /php.sh
ENTRYPOINT ["/php.sh"]
