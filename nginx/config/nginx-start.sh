#!/bin/bash
sed -i "s/%root-path%/$PROJECT_NAME/" /etc/nginx/conf.d/default.conf
sed -i "s/%ip-address%/$PHP_PORT_9000_TCP_ADDR/" /etc/nginx/conf.d/default.conf

nginx
