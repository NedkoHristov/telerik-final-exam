FROM ruby:2.6

WORKDIR /usr/src/app

COPY . ./

CMD ["ruby", "./tcp_server.rb"]

EXPOSE 80/tcp