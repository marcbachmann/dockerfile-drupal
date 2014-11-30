FROM jmoati/php-fpm
MAINTAINER Marc Bachmann <marc.brookman@gmail.com>

# Install dependencies
RUN apt-get update -q && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common python-software-properties python-setuptools curl mysql-client

# Install supervisord
RUN /usr/bin/easy_install supervisor supervisor-stdout
ADD ./start.sh /start.sh

# Install nginx
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y curl nginx && \
  chown -R www-data:www-data /var/lib/nginx

ADD ./supervisord.conf /etc/supervisord.conf
ADD ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["/start.sh"]

RUN chmod +x /start.sh && \
    apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
