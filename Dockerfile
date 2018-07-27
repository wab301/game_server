FROM ubuntu:16.04
LABEL maintainer="RapidClash Docker Maintainers <wangabin@xmfunny.com>"

RUN apt-get update && apt-get install -y tzdata \
    -y php \
    -y php-mysqli \
    -y php-zip \
    -y curl \
    -y sudo \
    -y wget make gcc openssh-server libmysqlclient-dev psmisc 

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -ie 's/short_open_tag = Off/short_open_tag = On/g' /etc/php/7.0/cli/php.ini

RUN apt-get install -y libreadline-dev libncurses-dev

# install go
WORKDIR /usr/local/
RUN curl -R -O https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && tar -zxf go1.10.3.linux-amd64.tar.gz \
    && rm -r go1.10.3.linux-amd64.tar.gz && ln -sf /usr/local/go/bin/* /usr/local/bin/

# install lua
RUN curl -R -O http://www.lua.org/ftp/lua-5.3.1.tar.gz && tar -zxvf lua-5.3.1.tar.gz && rm lua-5.3.1.tar.gz \
    && cd /usr/local/lua-5.3.1 && make linux install INSTALL_TOP=/usr/local/lua-5.3.1 && ln -sf /usr/local/lua-5.3.1 /usr/local/lua

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apt-get install -y git g++ nodejs
RUN npm install npm@latest -g && npm install webpack -g

WORKDIR /data
