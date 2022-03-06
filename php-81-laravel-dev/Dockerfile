FROM php:8.1-fpm-alpine3.15

LABEL description="Docker image for laravel development with php 8.1 based on alpine 3.15" \
      maintainer="moath.alhajrii@gmail.com"

# @see https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk update; \
    apk add --no-cache nodejs npm yarn openssh; \
    chmod +x /usr/local/bin/install-php-extensions; \
    IPE_GD_WITHOUTAVIF=1 install-php-extensions bcmath pdo_mysql pdo_pgsql pcntl xdebug gd; \
    php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer; \
    rm -rfv /tmp/*; \
    chmod -R 777 /root/
