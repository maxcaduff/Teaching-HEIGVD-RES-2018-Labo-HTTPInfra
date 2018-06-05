#!/bin/bash
# this script should be called with 3 or more arguments, the firsts being the static container's ips, followed by the dynamic container's ips (should include ports). The last argument is the number of static servers, the other half being deduced from the args num.


echo "<Proxy balancer://staticCluster>
" > txt
for ((i=1;i<= ${!#};i++));
do
  echo "	BalancerMember http://${!i}" >> txt
done

echo "
</Proxy>

<Proxy balancer://dynamicCluster>
" >> txt
for ((i=$((${!#} + 1));i<$#;i++));
do
  echo "	BalancerMember http://${!i}" >> txt
done

echo "
</Proxy>

<VirtualHost *:80>

	ServerName demo.res.ch

	ProxyPass 		/hire/ balancer://dynamicCluster/hire/
	ProxyPassReverse	/hire/ balancer://dynamicCluster/hire/

	ProxyPass		/ balancer://staticCluster/
	ProxyPassReverse 	/ balancer://staticCluster/

</VirtualHost>" >> txt

cat txt > /etc/apache2/sites-available/001-reverse-proxy.conf

rm txt

service apache2 reload

