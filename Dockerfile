ARG APP_IMAGE=php:8.1-fpm
FROM ${APP_IMAGE}

ARG INSTALL_WP_CLI=no
ARG INSTALL_COMPOSER=yes
ARG INSTALL_XDEBUG=yes
ARG INSTALL_MOOSH=no

COPY ./install.sh /opt/install.sh
RUN chmod +x /opt/install.sh
RUN /bin/bash -c "/opt/install.sh"

RUN if [ "$INSTALL_WP_CLI" = "yes" ]; then \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp; \
    fi

RUN if [ "$INSTALL_COMPOSER" = "yes" ]; then \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer global require "squizlabs/php_codesniffer=*" && \
    composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true && \
    composer global require --dev wp-coding-standards/wpcs; \
    fi

RUN if [ "$INSTALL_XDEBUG" = "yes" ]; then \
    pecl install xdebug-3.1.3 && \
    docker-php-ext-enable xdebug; \
    fi

RUN if [ "$INSTALL_MOOSH" = "yes" ]; then \
    curl -LsS https://box.moosh-online.com/installer.phar -o /usr/local/bin/moosh && \
    chmod +x /usr/local/bin/moosh; \
    fi
