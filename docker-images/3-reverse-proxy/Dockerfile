FROM php:7.0-apache

COPY conf/ /etc/apache2/
COPY changeAddresses.sh /bin/

RUN a2enmod proxy proxy_http
RUN a2ensite 000-* 001-*
RUN service apache2 restart
