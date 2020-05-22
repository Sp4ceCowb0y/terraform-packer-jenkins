#!/bin/bash
apt-get update
apt-get install -y nginx nodejs npm

groupadd node-app
useradd -d /app -s /bin/false -g node-app node-app

mv /tmp/app /app
chown -R node-app:node-app /app

echo 'user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
        worker_connections 768;
        # multi_accept on;
}

http {
  server {
    listen 80;
    location / {
      proxy_pass http://localhost:3000/;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
  }
}' > /etc/nginx/nginx.conf

service nginx restart

cd /app
npm install

echo '[Service]
ExecStart=/usr/bin/nodejs /app/index.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=node-app
User=node-app
Group=node-app
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/node-app.service

systemctl enable node-app
systemctl start node-app
