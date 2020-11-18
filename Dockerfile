FROM alpine:3.11

RUN apk add --update sudo musl openssl

ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update-cache add ca-certificates && \
    echo "https://dl.bintray.com/php-alpine/v3.11/php-7.4" >> /etc/apk/repositories

# install php and some extensions
RUN apk add --update-cache \
    php7 \
    php7-apache2 \
    php7-apcu \
    php7-bcmath \
    php7-bz2 \
    php7-calendar \
    php7-cgi \
    php7-common \
    php7-ctype \
    php7-curl \
    php7-dba \
    php7-dev \
    php7-doc \
    php7-dom \
    php7-exif \
    php7-ftp \
    php7-gd \
    php7-gettext \
    php7-gmp \
    php7-iconv \
    php7-imagick \
    php7-imap \
    php7-intl \
    php7-json \
    php7-ldap \
    php7-libsodium \
    php7-litespeed \
    php7-mbstring \
    php7-memcached \
    php7-mysqli \
    php7-mysqlnd \
    php7-odbc \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_dblib \
    php7-pdo_mysql \
    php7-pdo_odbc \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-pear \
    php7-pgsql \
    php7-phar \
    php7-phpdbg \
    php7-posix \
    php7-psr \
    php7-session \
    php7-shmop \
    php7-snmp \
    php7-soap \
    php7-sockets \
    php7-sqlite3 \
    php7-sysvmsg \
    php7-sysvsem \
    php7-sysvshm \
    php7-tidy \
    php7-timecop \
    php7-xdebug \
    php7-xml \
    php7-xmlreader \
    php7-xmlrpc \
    php7-xsl \
    php7-zip \
    php7-zlib 

RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR /" /etc/php7/php.ini &&\
    sed -i "s/log_errors = .*$/log_errors = On/" /etc/php7/php.ini


COPY ./apache.conf /etc/apache2/conf.d/

# Add apache to run and configure
ENV APACHE_LOG_DIR /var/log/apache2
ENV LOG_DIR /var/www/logs

RUN mkdir -p /run/apache2 &&\
    sed -i "s/Listen\ 80/Listen\ 8080/" /etc/apache2/httpd.conf \ 
    && sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/var/www/localhost/htdocs\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf &&\
    sed -i 's/#default_bits/default_bits/' /etc/ssl/openssl.cnf &&\
    ln -sf /proc/$$/fd/1 $APACHE_LOG_DIR/access.log &&\
    ln -sf /proc/$$/fd/2 $APACHE_LOG_DIR/error.log

WORKDIR /var/www/localhost/htdocs

ARG USER=phpuser
ENV USER $USER
ENV HOME /home/$USER
RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER \
    && echo "Set disable_coredump false" >> /etc/sudo.conf \
    && sudo chown -R $USER:$USER /var/www/localhost/htdocs \
    && sudo chmod -R 0755 /var/www/localhost/htdocs \
    && sudo chown -R $USER:$USER /run/apache2 \
    && sudo chmod -R 0755 /run/apache2  \
    && sudo chown -R $USER:$USER $LOG_DIR \
    && sudo chmod -R 0777 $LOG_DIR \
    && sudo chown -R $USER:$USER $APACHE_LOG_DIR \
    && sudo chmod -R 0755 $APACHE_LOG_DIR

USER $USER

EXPOSE 8080
CMD ["httpd" ,"-D" ,"FOREGROUND"]