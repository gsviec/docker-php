FROM gsviec/centos
MAINTAINER Phanbook <hello@gsviec.com>

RUN yum install php70w php70w-fpm php70w-opcache \
php70w-bcmath  php70w-cli php70w-common \
php70w-devel php70w-gd php70w-intl php70w-mbstring \
php70w-mcrypt php70w-mysqlnd php70w-pdo php70w-pecl-imagick \
php70w-xml  php70w-json --skip-broken -y

RUN yum remove ImageMagick-last-6.9.5.10-1.el7.remi.x86_64 -y
RUN yum install php70w-pecl-imagick -y

RUN git clone https://github.com/phpredis/phpredis.git

RUN cd phpredis && git checkout php7 && phpize && ./configure && make && make install

RUN echo "extension=redis.so" > /etc/php.d/redis.ini

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/bin/composer

##Install Phalcon

RUN yum install re2c -y
RUN git clone --depth=1 https://github.com/phalcon/zephir
RUN find zephir -type f -print0 | xargs -0 sed -i 's/sudo //g'
RUN cd zephir && ./install -c

RUN git clone --depth=1 git://github.com/phalcon/cphalcon.git
RUN cd cphalcon && zephir build
RUN echo "extension=phalcon.so" > /etc/php.d/phalcon.ini

###Clean 

RUN rm -rf zephir cphalcon
