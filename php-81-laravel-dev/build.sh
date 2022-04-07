#!/bin/bash

set -ex

cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1

USERNAME="$1"

IMAGE="$(basename "$(pwd)")"

docker build -t "$USERNAME/$IMAGE:latest" .

CONTAINER_ID=$(docker run -d "$USERNAME/$IMAGE:latest")

OS_VERSION=$(docker exec "$CONTAINER_ID" cat /etc/alpine-release)

GIT_VERSION=$(docker exec "$CONTAINER_ID" git --version | cut -c13-)

SUPERVISOR_VERSION=$(docker exec "$CONTAINER_ID" supervisord -v)

NGINX_VERSION=$(docker exec "$CONTAINER_ID" nginx -v 2>&1 | cut -c22-)

PHP_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo phpversion();')

PHP_MODULES=$(docker exec "$CONTAINER_ID" php -m)

XDEBUG_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo phpversion("xdebug");')

COMPOSER_VERSION=$(docker exec "$CONTAINER_ID" php -r 'echo explode(" ", exec("composer -V"))[2];')

NODE_VERSION=$(docker exec "$CONTAINER_ID" node -v | cut -c2-)

NPM_VERSION=$(docker exec "$CONTAINER_ID" npm -v)

YARN_VERSION=$(docker exec "$CONTAINER_ID" yarn -v)

docker rm --force --volumes "$CONTAINER_ID"

echo "# PHP 8.1 Laravel Development

![Alpine Linux version](https://img.shields.io/badge/ALPINE%20LINUX-$OS_VERSION-blue?style=for-the-badge)
![PHP version](https://img.shields.io/badge/PHP-$PHP_VERSION-blue?style=for-the-badge)
![Composer version](https://img.shields.io/badge/COMPOSER-$COMPOSER_VERSION-blue?style=for-the-badge)
![xDebug version](https://img.shields.io/badge/XDEBUG-$XDEBUG_VERSION-blue?style=for-the-badge)
![Node version](https://img.shields.io/badge/node-$NODE_VERSION-blue?style=for-the-badge)
![NPM version](https://img.shields.io/badge/npm-$NPM_VERSION-blue?style=for-the-badge)
![YARN version](https://img.shields.io/badge/yarn-$YARN_VERSION-blue?style=for-the-badge)
![Supervisor version](https://img.shields.io/badge/supervisor-$SUPERVISOR_VERSION-blue?style=for-the-badge)
![Nginx version](https://img.shields.io/badge/nginx-$NGINX_VERSION-blue?style=for-the-badge)
![Git version](https://img.shields.io/badge/git-$GIT_VERSION-blue?style=for-the-badge)

Docker image for Laravel development with PHP 8.1 based on Alpine Linux 3.15

## PHP extensions

\`\`\`txt
$PHP_MODULES
\`\`\`" >"README.md"
