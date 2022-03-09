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
    dockerhub_username='devmoath'
    image="$dockerhub_username/$dir:latest"
    readme_file="$dir/README.md"

    log_info "Building $image image"

    docker build --tag "$image" "$dir"

    log_info "Running $image image"

    CONTAINER_ID=$(docker run -d "$image")

    log_info "container id: $CONTAINER_ID"

    log_info "Collecting $image image info"

    OS_VERSION=$(docker exec "$CONTAINER_ID" cat /etc/alpine-release)
    log_info "OS version: $OS_VERSION"

    SUPERVISOR_VERSION=$(docker exec "$CONTAINER_ID" supervisord -v)
    log_info "supervisor version: $SUPERVISOR_VERSION"

    NGINX_VERSION=$(docker exec "$CONTAINER_ID" nginx -v 2>&1)
    NGINX_VERSION=${NGINX_VERSION#*/}
    log_info "nginx version: $NGINX_VERSION"

    PHP_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo phpversion();')
    log_info "PHP version: $PHP_VERSION"

    PHP_MODULES=$(docker exec "$CONTAINER_ID" php -m)
    log_info "$(echo "$PHP_MODULES" | tr '\r\n' ' ' | sed 's/  */ /g')"

    XDEBUG_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo phpversion("xdebug");')
    log_info "PHP xdebug version: $XDEBUG_VERSION"

    COMPOSER_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo explode(" ", exec("composer -V"))[2];')
    log_info "Composer version: $COMPOSER_VERSION"

    NODE_VERSION=$(docker exec "$CONTAINER_ID" node -v | cut -c2-)
    log_info "Node version: $NODE_VERSION"

    NPM_VERSION=$(docker exec "$CONTAINER_ID" npm -v)
    log_info "NPM version: $NPM_VERSION"

    YARN_VERSION=$(docker exec "$CONTAINER_ID" yarn -v)
    log_info "Yarn version: $YARN_VERSION"

    log_info "Stopping container id: $CONTAINER_ID"
    docker stop "$CONTAINER_ID"

    log_info "Removing container id: $CONTAINER_ID"
    docker rm "$CONTAINER_ID"

    log_info "Writing content for $readme_file"

    echo "# $dir

![Alpine Linux version](https://img.shields.io/badge/ALPINE%20LINUX-$OS_VERSION-blue?style=for-the-badge)
![PHP version](https://img.shields.io/badge/PHP-$PHP_VERSION-blue?style=for-the-badge)
![Composer version](https://img.shields.io/badge/COMPOSER-$COMPOSER_VERSION-blue?style=for-the-badge)
![xDebug version](https://img.shields.io/badge/XDEBUG-$XDEBUG_VERSION-blue?style=for-the-badge)
![Node version](https://img.shields.io/badge/node-$NODE_VERSION-blue?style=for-the-badge)
![NPM version](https://img.shields.io/badge/npm-$NPM_VERSION-blue?style=for-the-badge)
![YARN version](https://img.shields.io/badge/yarn-$YARN_VERSION-blue?style=for-the-badge)
![Supervisor version](https://img.shields.io/badge/supervisor-$SUPERVISOR_VERSION-blue?style=for-the-badge)
![Nginx version](https://img.shields.io/badge/nginx-$NGINX_VERSION-blue?style=for-the-badge)

Docker image for Laravel development with PHP $PHP_VERSION based on Alpine Linux $OS_VERSION

## PHP extensions

\`\`\`txt
$PHP_MODULES
\`\`\`" >"$readme_file"

    log_success "Finish writing content for $readme_file"
done
