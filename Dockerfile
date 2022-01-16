FROM ruby:2.6
COPY . /var/www/ruby
WORKDIR /var/www/ruby
CMD ["ruby","txc_server.rb"]