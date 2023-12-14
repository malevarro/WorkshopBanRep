#!/bin/bash
sudo dnf update -y
sudo dnf list | grep httpd
sudo dnf install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl status httpd.service
sudo systemctl enable httpd.service
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart httpd.service 