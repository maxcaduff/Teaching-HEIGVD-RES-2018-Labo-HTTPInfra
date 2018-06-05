#!/bin/bash
# this script should be called with 2 or more arguments, the first being the dynamic container's ip and the next ones being the statics container's ip. (should include ports.)


echo 'Header add Set-Cookie "ROUTEID=.%{BALANCER_WORKER_ROUTE}e; path=/" env=BALANCER_ROUTE_CHANGED
<Proxy balancer://staticCluster>
' > txt
for ((i=2;i<=$#;i++));
do
  eval echo "	BalancerMember http://\$$i route=\$(($i-1))" >> txt
done

echo "
	ProxySet stickysession=ROUTEID
</Proxy>

<VirtualHost *:80>

	ServerName demo.res.ch

	ProxyPass 		/hire/ http://$1/hire/
	ProxyPassReverse	/hire/ http://$1/hire/

	ProxyPass		/ balancer://staticCluster/
	ProxyPassReverse 	/ balancer://staticCluster/

</VirtualHost>" >> txt

cat txt > /etc/apache2/sites-available/001-reverse-proxy.conf

rm txt

service apache2 reload

