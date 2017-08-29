#This is a image for game_server
FROM ubuntu:16.04
MAINTAINER Abin Wang <wangabin0910@gmail.com>

RUN apt-get update 
RUN apt-get install -y wget make gcc openssh-server libmysqlclient-dev psmisc screen expect git vim subversion-tools 

# install go
WORKDIR /usr/local/
RUN wget https://storage.googleapis.com/golang/go1.8.1.linux-amd64.tar.gz
RUN tar -zxf go1.8.1.linux-amd64.tar.gz && rm -r go1.8.1.linux-amd64.tar.gz
RUN ln -sf /usr/local/go/bin/* /usr/local/bin/
ENV GOPATH /usr/local/go

# intall luajit
RUN apt-get install -y libreadline-dev libncurses-dev
WORKDIR /opt/
RUN wget http://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz
RUN tar -zxf LuaJIT-2.1.0-beta3.tar.gz && rm -rf LuaJIT-2.1.0-beta3.tar.gz
WORKDIR /opt/LuaJIT-2.1.0-beta3/
RUN make PREFIX=/usr/local/LuaJIT-2.1.0-beta3 && make install PREFIX=/usr/local/LuaJIT-2.1.0-beta3 
WORKDIR /usr/local/LuaJIT-2.1.0-beta3/bin/
RUN ln -sf luajit-2.1.0-beta3 luajit
RUN ln -sf /usr/local/LuaJIT-2.1.0-beta3 /usr/local/luajit 
RUN ln -s /usr/local/luajit/lib/libluajit-5.1.so.2 /usr/lib/libluajit-5.1.so.2
RUN ln -sf /usr/local/luajit/bin/luajit /usr/local/bin/luajit
RUN ln -sf /usr/local/luajit/share/luajit-2.0.4 /usr/local/share/luajit-2.0.4
RUN rm -rf /opt/LuaJIT-2.1.0-beta3

# install php
WORKDIR /opt/
RUN apt-get install -yy libxml2-dev && wget http://cn2.php.net/distributions/php-5.6.30.tar.gz
RUN tar -zxf php-5.6.30.tar.gz && rm -rf php-5.6.30.tar.gz
WORKDIR /opt/php-5.6.30/ 
RUN ./configure --prefix=/usr/local/php-5.6.30 --with-mysqli=/usr/bin/mysql_config --enable-sockets --enable-mbstring --enable-zip 
RUN make && make install
RUN ln -sf /usr/local/php-5.6.30 /usr/local/php && ln -sf /usr/local/php/bin/php /usr/local/bin
WORKDIR /opt
RUN rm -rf /opt/php-5.6.30
RUN /etc/init.d/ssh start