#!/bin/bash

echo "<VirtualHost *:80>

ProxyRequests off

ServerName demo.res.ch

Header add Set-Cookie "ROUTE_ID=.%{BALANCER_WORKER_ROUTE}e; path=/hire" env=BALANCER_ROUTE_CHANGED

<Proxy balancer://dynamic>
BalancerMember http://$3/hire route=1
BalancerMember http://$4/hire route=2
Order allow,deny
Allow from all

ProxySet lbmethod=byrequests stickysession=ROUTE_ID
</Proxy>


Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
<Proxy balancer://static_app>
BalancerMember http://$1/ route=s1
BalancerMember http://$2/ route=s2

Order allow,deny
Allow from all
ProxySet lbmethod=byrequests stickysession=ROUTEID
</Proxy>

ProxyPass '/hire' balancer://dynamic

ProxyPassReverse '/hire' balancer://dynamic

ProxyPass '/'  balancer://static_app/
ProxyPassReverse '/'  balancer://static_app/


</VirtualHost>" > /etc/apache2/sites-available/001-reverse-proxy.conf

service apache2 reload




