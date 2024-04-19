#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
cd /var/www/html
echo "<html><body>IP address of this instance: " > index.html
curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html
echo "</body></html>" >> index.html
