FROM phusion/baseimage:latest
MAINTAINER shufo <meikyowise@gmail.com>

RUN apt-get update
RUN apt-get -y install git subversion make g++ python curl chrpath && apt-get clean

# depot tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /usr/local/depot_tools
ENV PATH $PATH:/usr/local/depot_tools

# download v8
RUN cd /usr/local/src && fetch v8

# compile v8
RUN cd /usr/local/src/v8 && make native library=shared snapshot=off -j8

# install v8
RUN mkdir -p /usr/local/lib
RUN cp /usr/local/src/v8/out/native/lib.target/lib*.so /usr/local/lib
RUN echo "create /usr/local/lib/libv8_libplatform.a\naddlib /usr/local/src/v8/out/native/obj.target/tools/gyp/libv8_libplatform.a\nsave\nend" | ar -M
RUN cp -R /usr/local/src/v8/include /usr/local
RUN chrpath -r '$ORIGIN' /usr/local/lib/libv8.so
