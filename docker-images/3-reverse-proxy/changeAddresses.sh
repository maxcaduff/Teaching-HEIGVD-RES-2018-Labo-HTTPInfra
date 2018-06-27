#!/bin/bash

echo "<VirtualHost *:80>

ProxyRequests off
ServerName demo.res.ch

<Proxy balancer://dynamic>
BalancerMember http://$3/hire
BalancerMember http://$4/hire
Order allow,deny
Allow from all

ProxySet lbmethod=byrequests
</Proxy>

<Proxy balancer://static_app>
BalancerMember http://$1/
BalancerMember http://$2/

Order allow,deny
Allow from all
ProxySet lbmethod=byrequests
</Proxy>


ProxyPass '/hire' balancer://dynamic

ProxyPassReverse '/hire' balancer://dynamic


ProxyPass             '/manager' http://$5/
ProxyPassReverse     '/manager' http://$5/

ProxyPass '/'  balancer://static_app/
ProxyPassReverse '/'  balancer://static_app/


</VirtualHost>" > /etc/apache2/sites-available/001-reverse-proxy.conf

service apache2 reload




