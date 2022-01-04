FROM nginx:stable-alpine

# https://hub.docker.com/_/nginx
# NGINX will envsubst the *.conf.template file to /etc/nginx/conf.d/*.conf
COPY ./ci/router.production.conf.template /etc/nginx/templates/default.conf.template

EXPOSE 80
EXPOSE 443
