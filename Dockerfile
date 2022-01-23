# From prebaked image
#FROM ruby:2.6
#WORKDIR /usr/src/app
#COPY tcp_server.rb ./
#CMD ["ruby", "./tcp_server.rb"]
#EXPOSE 80/tcp

# From alpine image optimized for size and speed
FROM alpine:latest
MAINTAINER Nedko Hristov <nedelcho.hristov2001@gmail.com>
ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler
# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk update && \
    apk upgrade && \
    apk add $BUILD_PACKAGES && \
    apk add $RUBY_PACKAGES && \
    rm -rf /var/cache/apk/*
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . /usr/scr/app

CMD ["ruby", "./tcp_server.rb"]

RUN echo "Done"

EXPOSE 80/tcp
