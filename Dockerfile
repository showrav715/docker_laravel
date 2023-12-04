FROM php:8.2-fpm as php
# CREATE USER
RUN useradd -u 1000 -ms www-data
# INSTALL DEPENDENCIES
# for php laravel extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libmcrypt-dev \
    libreadline-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    libmag
# INSTALL PHP EXTENSIONS
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd
# INSTALL COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# SET WORKDIR
WORKDIR /var/www
# COPY SOURCE CODE
COPY --chown=www-data:www-data . .
# COPY .env
COPY .env.example .env
# COPY PERMISSIONS
RUN php artisan key:generate
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

RUN chmod -R 777 storage
RUN chmod -R 777 bootstrap/cache


ENTRYPOINT [ "docker/entrypoint.sh" ]



