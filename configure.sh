#!/bin/sh

cat << EOF > /etc/nginx/nginx.conf
worker_processes  4;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    #access_log  logs/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    #gzip  on;
    
    server {
       resolver 8.8.8.8;   #dns解析地址
       listen 89;          #代理监听端口
       location / {
             proxy_pass https://$host$request_uri;     #设定https代理服务器的协议和地址
             proxy_set_header HOST $host;
       
       }
    
    }
}

EOF

nginx -g 'daemon off;'
