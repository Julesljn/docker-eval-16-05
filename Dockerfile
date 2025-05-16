FROM composer:2 AS deps
WORKDIR /app

COPY src/composer.json src/composer.lock ./
RUN composer install \
      --no-dev --prefer-dist --optimize-autoloader \
      --no-interaction --no-progress --no-scripts


FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-dev zlib-dev \
 && docker-php-ext-install intl pdo_mysql

WORKDIR /var/www

COPY src .
COPY --from=deps /app/vendor ./vendor

RUN cp -a vendor /tmp/vendor-cache

RUN chown -R www-data:www-data storage bootstrap/cache || true

RUN printf '%s\n' \
  '#!/bin/sh' \
  'if [ ! -f /var/www/vendor/autoload.php ]; then' \
  '  echo "Restoring vendor directory…";' \
  '  mkdir -p /var/www/vendor;' \
  '  cp -a /tmp/vendor-cache/. /var/www/vendor/;' \
  'fi' \
  'exec php-fpm' \
  > /usr/local/bin/entrypoint.sh \
 && chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
