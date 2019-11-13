apk update
apk upgrade
apk add --no-cache --virtual .run-deps \
openssl
apk add --no-cache --virtual .build-deps \
alpine-sdk \
git \
openssl-dev

mkdir /build
cd /build
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
tar -zxf pcre-8.43.tar.gz
cd pcre-8.43
./configure
make
make install
cd /build

wget http://zlib.net/zlib-1.2.11.tar.gz
tar -zxf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make
make install
cd /build

git clone https://github.com/evanmiller/mod_zip.git

wget https://nginx.org/download/nginx-$STABLE.tar.gz
tar zxf nginx-$STABLE.tar.gz
cd nginx-$STABLE
./configure \
--sbin-path=/etc/nginx/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/etc/nginx/nginx.pid \
--with-pcre=../pcre-8.43 \
--with-zlib=../zlib-1.2.11 \
--with-http_ssl_module \
--with-stream \
--with-mail=dynamic \
--with-http_addition_module \
--add-dynamic-module=/build/mod_zip
make
make install
ln -sf /etc/nginx/nginx /bin/nginx

cd /
rm -rf /build

apk del .build-deps

# forward request and error logs to docker log collector
mkdir /var/log/nginx
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log
