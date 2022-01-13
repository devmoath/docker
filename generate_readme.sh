#!/usr/bin/env bash

set -e

NOCOLOR='\033[0m'
LIGHTBLUE='\033[1;34m'
GREEN='\033[0;32m'
LIGHTRED='\033[1;31m'

function log_error() {
    echo -e "${LIGHTRED}$(date +"%Y-%m-%d %H:%M:%S") ERROR: $*${NOCOLOR}"
}

function log_info() {
    echo -e "${LIGHTBLUE}$(date +"%Y-%m-%d %H:%M:%S") INFO: $*${NOCOLOR}"
}

function log_success() {
    echo -e "${GREEN}$(date +"%Y-%m-%d %H:%M:%S") SUCCESS: $*${NOCOLOR}"
}

if ! command -v docker &>/dev/null; then
    log_error "Docker is not installed"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    log_error "Docker is not running"
    exit 1
fi

dirs=(
    'php-8-laravel-dev'
    'php-74-laravel-dev'
    'php-81-laravel-dev'
)

log_info "Avaliable images (${dirs[*]})"

for dir in "${dirs[@]}"; do
    image="devmoath/$dir:latest"
    readme_file="$dir/README.md"

    log_info "pulling $image image"

    docker pull "$image"

    log_info "collecting $image image info"

    OS_VERSION=$(docker run --rm "$image" cat /etc/alpine-release)
    PHP_VERSION=$(docker run --rm "$image" php -r 'echo phpversion();')
    PHP_MODULES=$(docker run --rm "$image" php -m)
    XDEBUG_VERSION=$(docker run --rm "$image" php -r 'echo phpversion("xdebug");')
    COMPOSER_VERSION=$(docker run --rm "$image" php -r 'echo explode(" ", exec("composer -V"))[2];')
    NODE_VERSION=$(docker run --rm "$image" node -v)
    NPM_VERSION=$(docker run --rm "$image" npm -v)
    YARN_VERSION=$(docker run --rm "$image" yarn -v)

    log_info "os version: $OS_VERSION"
    log_info "php version: $PHP_VERSION"
    log_info "$(echo "$PHP_MODULES" | tr '\r\n' ' ' | sed 's/  */ /g')"
    log_info "php xdebug version: $XDEBUG_VERSION"
    log_info "composer version: $COMPOSER_VERSION"
    log_info "node version: $NODE_VERSION"
    log_info "npm version: $NPM_VERSION"
    log_info "yarn version: $YARN_VERSION"

    log_info "writing content for $readme_file"

    echo "# $dir

![PHP version](https://img.shields.io/badge/PHP-$PHP_VERSION-blue?style=for-the-badge)
![Composer version](https://img.shields.io/badge/COMPOSER-$COMPOSER_VERSION-blue?style=for-the-badge)
![xDebug version](https://img.shields.io/badge/XDEBUG-$XDEBUG_VERSION-blue?style=for-the-badge)
![Node version](https://img.shields.io/badge/node-$NODE_VERSION-blue?style=for-the-badge)
![NPM version](https://img.shields.io/badge/npm-$NPM_VERSION-blue?style=for-the-badge)
![YARN version](https://img.shields.io/badge/yarn-$YARN_VERSION-blue?style=for-the-badge)

Docker image for laravel development with php $PHP_VERSION based on alpine $OS_VERSION

## PHP extensions

\`\`\`txt
$PHP_MODULES
\`\`\`" >"$readme_file"

    log_success "finish writing content for $readme_file"
done
