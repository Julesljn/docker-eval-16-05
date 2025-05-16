FROM composer:2 AS deps

WORKDIR /app
COPY src/composer.json src/composer.lock ./
RUN composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction --no-progress --no-scripts

FROM php:8.3-fpm-alpine

RUN apk add --no-cache icu-libs icu-data-full zlib \
    && apk add --no-cache --virtual .build-deps icu-dev zlib-dev \
    && docker-php-ext-install intl pdo_mysql \
    && apk del .build-deps

WORKDIR /var/www
COPY src .
COPY --from=deps /app/vendor ./vendor

RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data /var/www

USER www-data
EXPOSE 9000
CMD ["php-fpm"]
