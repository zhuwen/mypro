#!/bin/sh

cat << EOF > /etc/nginx/nginx.conf
worker_processes  4;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  300;
    server_tokens off;
    server {
        listen 18081;
        server_name _;
        location / {
          resolver 8.8.8.8;
          proxy_pass $scheme://$host$request_uri;
        }
}

EOF

nginx -g 'daemon off;'
