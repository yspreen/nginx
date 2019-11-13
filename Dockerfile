FROM alpine:3.10

ARG STABLE=1.16.1

ADD build-nginx.sh /build.sh
RUN /build.sh; rm /build.sh

VOLUME ["/var/cache/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
