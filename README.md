PHP 7 Web Development Container
===============================

Docker container set up for local Drupal development purposes. Targeted to Drupal
but works well for most LEMP stack purposes. Not really doing things the 'docker way',
but supremely convenient for managing local development environments.

A good bit of this was initially created as a customization of wadmiraal's
docker-drupal container at (https://github.com/wadmiraal/docker-drupal)

Summary
-------

The image is setup with the following:

* Ubuntu 16.04
* MySQL 5.7
* PHP 7.0 FPM
* NGINX 1.10
* Composer
* Drush
* XDebug

The mysql setup is a base install. Anyone using this will need to run through
mysql_installdb and/or mysql_secure_installation to get things configured
properly.

I use an approach that mounts volumes back for all persistent data so that it's
optimized for my personal development workflow. Below is an example of my typical
docker-compose.yml file using this image:

~~~~
web:
  image: azterix/php7-webdev-fpm
  container_name: bvt-v2-fpm
  ports:
   - "80:80"
   - "443:443"
   - "2222:22"
  volumes:
   - ../www:/var/www/html
   - ./data/share:/share
   - ./data/mysql:/var/lib/mysql
   - ./config/settings.php:/var/www/html/sites/default/settings.php
   - ./config/webdev-php.ini:/etc/php/7.0/fpm/conf.d/99-webdev-php.ini
~~~~
