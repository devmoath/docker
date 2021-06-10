FROM php:8

LABEL description="Docker image for php 8 with xdebug and composer."
LABEL maintainer="moath.alhajrii@gmail.com"

RUN apt-get update && apt-get install --yes --quiet --no-install-recommends \
    libzip-dev \
    libpng-dev \
    zip \
    unzip && \
    docker-php-ext-install mysqli gd zip && \
    pecl install xdebug-3.0.4 && \
    docker-php-ext-enable xdebug gd

COPY --from=composer:2.1.2 /usr/bin/composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
ENV COMPOSER_VERSION 2.1.2
ENV XDEBUG_MODE coverage
