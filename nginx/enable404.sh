#!/bin/sh
set -e
sed -i 's/#error_page  404/error_page  404/' /etc/nginx/conf.d/default.conf
exit 0
