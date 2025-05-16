FROM composer:2 AS deps

WORKDIR /app
COPY src/composer.json src/composer.lock ./
RUN composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction --no-progress

FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-data icu-libs zlib && \
    docker-php-ext-install intl pdo_mysql

WORKDIR /var/www

COPY src .

COPY --from=deps /app/vendor ./vendor

RUN chown -R www-data:www-data storage bootstrap/cache

USER www-data
CMD ["php-fpm"]
