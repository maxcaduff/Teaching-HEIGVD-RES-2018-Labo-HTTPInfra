#!/bin/bash
# this script should be called with 2 arguments, the first being the static ip and the second being the dynamic ip. (should include ports.)

echo "<VirtualHost *:80>

	ServerName demo.res.ch

	ProxyPass 		/hire/ http://$2/hire/
	ProxyPassReverse	/hire/ http://$2/hire/

	ProxyPass 		/ http://$1/
	ProxyPassReverse 	/ http://$1/
</VirtualHost>" > /etc/apache2/sites-available/001-reverse-proxy.conf

service apache2 reload
