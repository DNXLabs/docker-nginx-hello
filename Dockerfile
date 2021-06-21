FROM nginx:mainline-alpine

COPY ssl-generator.sh /docker-entrypoint.d/ssl-generator.sh
RUN apk add --no-cache \
            bash \
            shadow \
            openssl && \
            chmod +x /docker-entrypoint.d/ssl-generator.sh && \
            mkdir -p /opt/ssl

RUN rm /etc/nginx/conf.d/*
ADD hello.conf /etc/nginx/conf.d/
ADD index.html /usr/share/nginx/html/