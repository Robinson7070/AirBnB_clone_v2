#!/usr/bin/env bash
# sets up my web servers for the deployment of web_static

set -e  # Exit script immediately if any command returns a non-zero status

echo -e "\e[1;32m START\e[0m"

#--Updating the packages
sudo apt-get -y update
sudo apt-get -y install nginx
echo -e "\e[1;32m Packages updated\e[0m"
echo

#--configure firewall
sudo ufw allow 'Nginx HTTP'
echo -e "\e[1;32m Allow incoming NGINX HTTP connections\e[0m"
echo

#--created the dir
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo -e "\e[1;32m Directories created"
echo

#--adds test string
echo "<h1>Welcome to www.beta-scribbles.tech</h1>" | sudo tee /data/web_static/releases/test/index.html > /dev/null
echo -e "\e[1;32m Test string added\e[0m"
echo

#--prevent overwrite
if [ -d "/data/web_static/current" ];
then
    echo "Path /data/web_static/current exists"
    sudo rm -rf /data/web_static/current;
fi;
echo -e "\e[1;32m Prevent overwrite\e[0m"
echo

#--create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data

# Check NGINX configuration syntax before restarting
sudo nginx -t

sudo sed -i '38i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

sudo ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
echo -e "\e[1;32m Symbolic link created\e[0m"
echo

#--restart NGINX
sudo service nginx restart
echo -e "\e[1;32m Restart NGINX\e[0m"

