FROM php:8-fpm

LABEL description="Docker image for laravel development with php 8, xdebug, composer, and needed php ext."
LABEL maintainer="moath.alhajrii@gmail.com"

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -

RUN apt-get update && apt-get install --yes --quiet --no-install-recommends \
        openssl \
        libxml2-dev \
        libpq-dev \
        libzip-dev \
        libonig-dev \
        libmcrypt-dev \
        libgmp-dev \
        libpng-dev \
        git \
        telnet \
        nodejs \
        zip \
        unzip \
        nano && \
    docker-php-ext-install pcntl \
        bcmath \
        mysqli \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
        gmp && \
    pecl install xdebug-3.0.4 && \
    docker-php-ext-enable xdebug gd

COPY --from=composer:2.1.2 /usr/bin/composer /usr/bin/composer

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 2.1.2
ENV XDEBUG_MODE coverage
