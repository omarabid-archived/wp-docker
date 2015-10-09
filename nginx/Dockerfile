FROM nginx:1.9.0

LABEL version="1.0"

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/conf.d/default.conf

# Nginx startup script
ADD config/nginx-start.sh /opt/bin/nginx-start.sh
RUN chmod u=rwx /opt/bin/nginx-start.sh

# SSL Certificate
RUN mkdir /etc/nginx/ssl
COPY certificate/nginx.crt /etc/nginx/ssl/nginx.crt
COPY certificate/nginx.key /etc/nginx/ssl/nginx.key

ENTRYPOINT ["/opt/bin/nginx-start.sh"]
