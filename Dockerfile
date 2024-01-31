ARG PHP_VERSION=7.4
FROM php:7.4-fpm-alpine

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY --chown=www-data:www-data ./index.php /var/www/html

RUN apk update && apk upgrade
RUN apk add build-base autoconf libzip-dev libpng-dev libjpeg-turbo-dev libwebp-dev bash mariadb-client mc nano

# Install cron
RUN apk add --no-cache dcron

# копируем задание которое будет запускать crond.sh для переноса новых заданий из файла в crontab core/scheduler/crontabs/$USER
COPY ./crontabs/cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron

# Копируем файл который будет отлеживать изменения в crontab
COPY ./crontabs/crond.sh /root/crond.sh
RUN chmod +x /root/crond.sh

RUN touch /var/log/cron.log

#RUN pecl install xdebug-3.1.0
RUN docker-php-ext-configure gd --with-jpeg --with-webp && docker-php-ext-install gd
RUN docker-php-ext-install exif
RUN docker-php-ext-install zip
RUN docker-php-ext-install bz2
RUN docker-php-ext-install pdo_mysql

# Установка и включение расширения GD
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd
    
# Установка и включение расширения intl
RUN apt-get install -y \
    libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl

RUN composer global config minimum-stability alpha
ENV PATH=/root/.composer/vendor/bin:$PATH

USER www-data

RUN composer global require modmore/gitify:^2
ENV PATH="/home/www-data/.composer/vendor/bin:${PATH}"
