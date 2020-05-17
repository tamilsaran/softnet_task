FROM alpine:3.11

# Install Dependencies
RUN apk --no-cache add openssl curl ca-certificates bash

# Install Nginx mainline
RUN printf "%s%s%s\n" \
    "http://nginx.org/packages/mainline/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories && \
    curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub && \
    openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout && \
    mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ && \
    apk --no-cache add nginx && \
    mkdir /home/www-data

# Change Working Directory
WORKDIR /home/www-data

# Copy Source Code
COPY . .

# Setup Configs
RUN mv nginx.conf /etc/nginx/nginx.conf && \
    mv start-container /usr/local/bin/start-container && \
    chmod +x /usr/local/bin/start-container

# Create SSL Self-signed Certs
RUN bash openssl.sh && rm openssl.sh

# Add User
RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data && \
    chown -R www-data:www-data /home/www-data

# Setting logs
RUN ln -sf /dev/stdout /tmp/access.log \
    && ln -sf /dev/stderr /tmp/error.log

# Expose Port
EXPOSE 8880 8443

# Switch User
USER www-data

ENTRYPOINT [ "start-container" ]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8880