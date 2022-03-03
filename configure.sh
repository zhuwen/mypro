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
    		resolver 8.8.8.8;
    		resolver_timeout 5s;
    		listen 10108;
    		location / {
				proxy_pass $scheme://$host$request_uri; 
				proxy_set_header Host $http_host; 
				proxy_buffers 256 4k; 
				proxy_max_temp_file_size 0;	 
				proxy_connect_timeout 30;	 
				proxy_cache_valid 200 302 10m;	 
				proxy_cache_valid 301 1h; 
				proxy_cache_valid any 1m;
    		}
	}
}
EOF

nginx -g 'daemon off;'
