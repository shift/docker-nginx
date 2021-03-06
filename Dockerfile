FROM shift/ubuntu:16.04

MAINTAINER Vincent Palmer <shift@someone.section.me>

WORKDIR /usr/local/src
RUN apt-get update \
    && apt-get install --no-install-recommends --yes build-essential curl git-core libssl-dev libpcre3-dev python-pip \
    && pip install elasticsearch \
    && curl -L -O http://nginx.org/download/nginx-1.9.10.tar.gz \
    && curl -L -O https://github.com/nbs-system/naxsi/archive/0.54rc3.tar.gz \
    && curl -L -O https://github.com/wandenberg/nginx-push-stream-module/archive/0.5.1.tar.gz \
    && tar xfvz 0.5.1.tar.gz \
    && tar xfvz nginx-1.9.10.tar.gz \
    && tar xfvz 0.54rc3.tar.gz \
    && cd nginx-1.9.10 \
    && ./configure --prefix=/usr --add-module=../naxsi-0.54rc3/naxsi_src/ --add-module=../nginx-push-stream-module-0.5.1 --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-log-path=/var/log/nginx/access.log --http-proxy-temp-path=/var/lib/nginx/proxy --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --without-mail_pop3_module --without-mail_smtp_module --without-mail_imap_module --without-http_uwsgi_module --without-http_scgi_module --with-ipv6 --with-http_gunzip_module --with-http_gzip_static_module --with-http_auth_request_module --with-http_v2_module \
    && make \
    && make install \
    && cd .. \
    && cd naxsi-0.54rc3/nxapi \
    && python setup.py install \
    && cd .. \
    && rm -rf nginx-1.8.0 nginx-1.8.0.tar.gz 0.54rc3.tar.gz \
    && apt-get remove --yes build-essential \
    && apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /etc/nginx
VOLUME /var/log/nginx
VOLUME /var/lock
VOLUME /var/run
VOLUME /var/lib/nginx/fastcgi

EXPOSE 80/tcp
EXPOSE 443/tcp

ENTRYPOINT ["/usr/sbin/nginx"]
