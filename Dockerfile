FROM composer:2 AS deps
WORKDIR /app

COPY src/composer.json src/composer.lock ./
RUN composer install \
      --no-dev --prefer-dist --optimize-autoloader \
      --no-interaction --no-progress --no-scripts

# 2. image d’exécution PHP-FPM  
FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-dev zlib-dev \
 && docker-php-ext-install intl pdo_mysql \
 && apk del icu-dev zlib-dev

WORKDIR /var/www

# code applicatif + vendor
COPY src .
COPY --from=deps /app/vendor ./vendor

# droits écriture Laravel
RUN chown -R www-data:www-data storage bootstrap/cache || true

USER www-data
CMD ["php-fpm"]
