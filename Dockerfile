FROM php:8.3-fpm-alpine

ARG user=laravel
ARG uid=1000

RUN apk add --no-cache \
        git curl zip unzip libpng-dev oniguruma-dev libxml2-dev icu-dev icu-data bash \
    && docker-php-ext-install pdo_mysql mbstring bcmath gd intl opcache \
    && cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && echo "opcache.memory_consumption=128"       >> "$PHP_INI_DIR/php.ini" \
    && echo "opcache.max_accelerated_files=10000"  >> "$PHP_INI_DIR/php.ini" \
    && echo "opcache.validate_timestamps=0"        >> "$PHP_INI_DIR/php.ini"

COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

RUN addgroup -g ${uid} ${user} \
 && adduser  -G ${user} -u ${uid} -D ${user}

WORKDIR /var/www

COPY --chown=${user}:${user} src/composer.json src/composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --no-progress --no-scripts

COPY --chown=${user}:${user} src/ .

RUN composer run-script post-autoload-dump --no-interaction \
 && php artisan package:discover --ansi

RUN chown -R ${user}:${user} /var/www \
 && chmod -R 755 storage bootstrap/cache

USER ${user}

EXPOSE 9000
CMD ["php-fpm"]
