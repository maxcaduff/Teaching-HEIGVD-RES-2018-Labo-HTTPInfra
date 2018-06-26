FROM php:7.0-apache

COPY conf/ /etc/apache2/
COPY changeAddresses-stickySession.sh /bin/

#Enable load balancer round-robin
RUN a2enmod proxy_balancer lbmethod_byrequests

#Enable the laod balancer
RUN a2enmod proxy_balancer

RUN a2enmod proxy proxy_http
RUN a2ensite 000-* 001-*
RUN service apache2 restart
