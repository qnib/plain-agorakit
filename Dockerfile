FROM qnib/uplain-caddy

ENV SITE_ROOT=/opt/agorakit/public \
    SITE_PORT=8080 \
    SITE_HOST=0.0.0.0
RUN apt-get update \
 && apt-get install -y git software-properties-common mercurial language-pack-en-base \
 && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
 && apt-get update \
 && apt-get install -y php7.0 curl php7.0-mbstring php7.0-xml php7.0-fpm \
 && curl -s https://getcomposer.org/installer | php \
 && mv /composer.phar /usr/local/bin/composer \
 && mkdir -p /opt/agorakit \
 && chown -R www-data: /opt/agorakit
USER www-data
RUN git clone https://github.com/philippejadin/agorakit.git /opt/agorakit \
 && cd /opt/agorakit \
 && composer install
USER root
COPY etc/caddy/config /etc/caddy/
RUN mkdir -p /run/php \
 && apt-get install -y php7.0-sqlite3 php7.0-mysql vim
COPY opt/qnib/entry/00-agorakit-key-gen.sh /opt/qnib/entry/
ENV ENTRYPOINTS_DIR=/opt/qnib/entry/
COPY etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/
