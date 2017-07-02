FROM ubuntu:16.04
MAINTAINER Chris Zoellick <azterix@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# Install packages.
RUN apt-get update && apt-get install -y \
	php7.0 \
	php7.0-fpm \
	php7.0-cli \
	php7.0-common \
	php7.0-mbstring \
	php7.0-gd \
	php7.0-intl \
	php7.0-xml \
	php7.0-mysql \
	php7.0-mcrypt \
	php7.0-zip \
	php-xdebug \
	php-curl \
	nginx \
	vim \
	git \
	libpng12-dev \
	libjpeg-dev \
	libpq-dev \
	curl \
	mysql-server \
	mysql-client \
	openssh-server \
	wget \
	unzip \
	cron \
	libmcrypt-dev \
	ssl-cert \
	supervisor \
	&& apt-get clean

# Setup SSH.
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY nginx.conf /etc/nginx/sites-available/default

# update php.ini config
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush
RUN composer global require drush/drush
RUN composer global update
# Unfortunately, adding the composer vendor dir to the PATH doesn't seem to work. So:
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush
# Setup XDebug.
RUN echo "xdebug.max_nesting_level = 300" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini

ENV SHELL=bash

WORKDIR /var/www

EXPOSE 80 3306 22 443

CMD service mysql start && \
	service php7.0-fpm start && \
	service nginx start && \
	tail -f /var/log/nginx/*.log
