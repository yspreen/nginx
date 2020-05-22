apk update
apk upgrade
apk add --no-cache --virtual .run-deps \
openssl pcre zlib
apk add --no-cache --virtual .build-deps \
alpine-sdk pcre-dev zlib-dev \
git \
openssl-dev

mkdir /build
cd /build

git clone https://github.com/evanmiller/mod_zip.git

wget https://nginx.org/download/nginx-$STABLE.tar.gz
tar zxf nginx-$STABLE.tar.gz
cd nginx-$STABLE
./configure \
--prefix=/etc/nginx \
--sbin-path=/etc/nginx/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/etc/nginx/nginx.pid \
--with-pcre \
--with-http_ssl_module \
--with-stream \
--with-mail=dynamic \
--with-http_addition_module \
--add-module=/build/mod_zip
make
make install
ln -sf /etc/nginx/nginx /bin/nginx

cd /
rm -rf /build

apk del .build-deps

# forward request and error logs to docker log collector
mkdir /var/log/nginx
ln -sf /dev/stdout /etc/nginx/logs/access.log
ln -sf /dev/stderr /etc/nginx/logs/error.log

addgroup -S nginx
adduser -S -G nginx -H -s /bin/false -D nginx
addgroup -S www
adduser -S -G www -H -s /bin/false -D www
