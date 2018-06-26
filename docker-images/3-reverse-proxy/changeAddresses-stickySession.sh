#!/bin/bash
# this script should be called with 2 arguments, the first being the static ip and the second being the dynamic ip. (should include ports.)

echo "<VirtualHost *:80>

#Turn off ProxyRequests to avoid any unwanted traffic.
ProxyRequests off
# the DNS name that host can use to attempt our service
ServerName demo.res.ch

Header add Set-Cookie "ROUTE_ID=.%{BALANCER_WORKER_ROUTE}e; path=/hire" env=BALANCER_ROUTE_CHANGED

#define the dynamic server
<Proxy balancer://dynamic>
BalancerMember http://$3/hire route=1
BalancerMember http://$4/hire route=2
Order allow,deny
Allow from all

#
ProxySet lbmethod=byrequests stickysession=ROUTE_ID
</Proxy>


Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
#Define the static server (un cluster: un grap de serveur)
<Proxy balancer://static_app>
BalancerMember http://$1/ route=s1
BalancerMember http://$2/ route=s2

Order allow,deny
Allow from all
ProxySet lbmethod=byrequests stickysession=ROUTEID
</Proxy>

# handle the dynamic content provides by dockerised express
# Mapping the inbound request handler fot thre ressource "/api/wine"
ProxyPass '/hire' balancer://dynamic

# outbound : HTTP response back to the client
ProxyPassReverse '/hire' balancer://dynamic

#  Handle the static content provides by dockerised apache static
ProxyPass '/'  balancer://static_app/
ProxyPassReverse '/'  balancer://static_app/


</VirtualHost>" > /etc/apache2/sites-available/001-reverse-proxy.conf

service apache2 reload




