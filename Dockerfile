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
        libmcrypt-dev \
        libldap2-dev \
        zlib1g-dev \
        libtidy-dev \
        
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) bcmath calendar iconv intl mbstring mysqli opcache pdo pdo_mysql soap zip imap tidy\
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
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
