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
       proxy_connect;
       proxy_connect_allow            443 563;
       location / {
             proxy_pass https://$host$request_uri;     #设定https代理服务器的协议和地址
             proxy_set_header HOST $host;
             proxy_buffers 256 4k;
             proxy_max_temp_file_size 0k;
             proxy_connect_timeout 30;
             proxy_send_timeout 60;
             proxy_read_timeout 60;
             proxy_next_upstream error timeout invalid_header http_502;
       }
       error_page   500 502 503 504  /50x.html;
       location = /50x.html {
             root   html;
       }
    }
}

EOF

nginx -g 'daemon off;'
