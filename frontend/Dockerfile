#### BUILDER IMAGE  ####
FROM docker.io/node:18 as builder

WORKDIR /opt/builder

COPY . .

#### OUTPUT IMAGE ####
FROM docker.io/nginx:stable-alpine

# Each time this container is ran, the value that's provided for this env var
# determines where the frontend will try to request feed information from:
ENV SUBSTRATE_TELEMETRY_URL=

WORKDIR /app

COPY --from=builder /opt/builder/frontend/scripts/*.sh /usr/local/bin/
COPY --from=builder /opt/builder/frontend/build /app
COPY --from=builder /opt/builder/frontend/nginx/nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache bash && \
    chown -R nginx:nginx /app && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid && \
    rm /etc/nginx/conf.d/default.conf

# UID= 101
USER nginx
EXPOSE 8000

CMD ["/usr/local/bin/start.sh"]
