FROM php:7.2-apache
MAINTAINER Jose Pablo Espinoza <josepablo.espinoza@gmail.com>

COPY ./limesurvey.tgz /

RUN buildDeps=" \
        default-libmysqlclient-dev \
        libsasl2-dev \
    " \
    runtimeDeps=" \
        curl \
        wget \
        unzip \
        libc-client-dev \
        libkrb5-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install bcmath calendar iconv intl mbstring mysqli opcache pdo_mysql soap zip imap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && tar -xzf /limesurvey.tgz --strip-components=1 -C /var/www/html \
    && rm /limesurvey.tgz \
    && wget -O /arrayTextAdapt.zip http://extensions.sondages.pro/IMG/auto/arrayTextAdapt.zip \
    && unzip /arrayTextAdapt.zip -d / \
    && rm /arrayTextAdapt.zip \
    && mv /arrayTextAdapt /var/www/html/application/core/plugins \
    && chown -Rf www-data:www-data /var/www/html
    
WORKDIR /var/www/html
