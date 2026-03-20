#!/bin/bash
set -e

dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>${var.environment} - $(hostname)</h1>" > /var/www/html/index.html