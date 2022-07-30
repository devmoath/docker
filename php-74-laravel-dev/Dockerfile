FROM php:7.4-fpm-alpine

LABEL description="Docker image for Laravel development with PHP 7.4 based on Alpine Linux 3.15" \
      maintainer="moath.alhajrii@gmail.com"

# @see https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions; \
    chmod -R 777 /root

RUN apk update; \
    apk add --no-cache nodejs npm openssh nginx supervisor git bash linux-headers;

RUN install-php-extensions bcmath pdo_mysql pdo_pgsql pcntl xdebug gd calendar zip exif redis @composer

RUN npm install --global pnpm npx yarn

RUN rm -rfv /tmp/*
