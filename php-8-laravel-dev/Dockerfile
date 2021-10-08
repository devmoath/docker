FROM php:8-fpm

LABEL description="Docker image for laravel development with php 8-fpm." \
      maintainer="moath.alhajrii@gmail.com"

RUN curl --silent --location https://deb.nodesource.com/setup_16.x | bash; \
    apt-get update; \
    apt-get install --yes --quiet --no-install-recommends \
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
        vim \
        nano \
        wget \
        libicu-dev; \
    docker-php-ext-install pcntl \
        bcmath \
        mysqli \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        zip \
        gd \
        gmp \
        intl; \
    pecl install xdebug-3.1.0; \
    docker-php-ext-enable xdebug gd; \
    rm -rfv /var/lib/apt/lists/*

COPY --from=composer:2.1.9 /usr/bin/composer /usr/bin/composer

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

RUN printf "# composer php cli ini settings\n\
date.timezone=UTC\n\
memory_limit=-1\n\
" > $PHP_INI_DIR/php-cli.ini

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp \
    COMPOSER_VERSION=2.1.9 \
    XDEBUG_MODE=coverage

RUN curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/keys.dev.pub \
        --url https://composer.github.io/snapshots.pub; \
    curl \
        --silent \
        --fail \
        --location \
        --retry 3 \
        --output /tmp/keys.tags.pub \
        --url https://composer.github.io/releases.pub; \
    composer --ansi --version --no-interaction; \
    composer diagnose --ansi

CMD ["php-fpm"]
