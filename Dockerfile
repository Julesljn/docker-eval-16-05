FROM composer:2 AS deps
WORKDIR /app

COPY src/composer.json src/composer.lock ./
RUN composer install \
      --no-dev --prefer-dist --optimize-autoloader \
      --no-interaction --no-progress --no-scripts


FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-dev zlib-dev git zip unzip \
 && docker-php-ext-install intl pdo_mysql

WORKDIR /var/www

COPY --from=deps /usr/bin/composer /usr/bin/composer

COPY src .
COPY --from=deps /app/vendor ./vendor

RUN printf '%s\n' \
  '#!/bin/sh' \
  'set -e' \
  'if [ ! -f /var/www/vendor/autoload.php ]; then' \
  '  echo "vendor/ absent → composer install…";' \
  '  composer install --no-dev --prefer-dist --no-interaction --quiet --optimize-autoloader;' \
  'fi' \
  'exec php-fpm' \
  > /usr/local/bin/entrypoint.sh \
 && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
