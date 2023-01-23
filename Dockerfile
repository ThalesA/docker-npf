FROM ubuntu:20.04

#Sem interação humana
ARG DEBIAN_FRONTEND=noninteractive

#Updating operating system
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

##Installing essential packages
RUN apt-get -y install apt-utils software-properties-common curl bash-completion vim git zip unzip

##Installing NGINX
RUN apt-get -y install nginx

##Adding PHP repository
RUN add-apt-repository -y ppa:ondrej/php && apt-get update

#Installing PHP and extensions
RUN apt-get -y install php8.1-cli php8.1-common php8.1-fpm php8.1-mysql \
php8.1-curl php8.1-dev php8.1-mbstring php8.1-gd php8.1-redis php8.1-xml php8.1-zip php8.1-intl

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install xdebug and redis
RUN pecl install xdebug redis

#Configuring Xdebug
RUN echo "zend_extension=/usr/lib/php/20200930/xdebug.so" >> /etc/php/8.1/fpm/php.ini
RUN echo "zend_extension=/usr/lib/php/20200930/xdebug.so" >> /etc/php/8.1/cli/php.ini


# Clean up
RUN rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE  80

CMD service php8.1-fpm start && nginx -g "daemon off;"