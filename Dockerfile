# docker run -v /Users/marcbachmann/Development/devirex/lipivir-website:/data -v /Users/marcbachmann/Development/suitart/ansible/templates/nginx/nginx.conf:/etc/nginx/nginx.conf-P --link fpm:fpm dockerfile/nginx
FROM jmoati/php-fpm
MAINTAINER Marc Bachmann <marc.bachmann@suitart.com>


# To prevent front end warnings

# apt-get install -y software-properties-common build-essential unzip curl wget git python

RUN apt-get update -q && \
    apt-get install -y software-properties-common python-software-properties nano
    # software-properties-common build-essential unzip curl wget git python

RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y curl nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

EXPOSE 80
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./start /start

RUN chmod +x /start && \
    apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
