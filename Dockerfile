FROM ruby:2.3.1

RUN mkdir -p /oasis-server
WORKDIR /oasis-server

COPY . /oasis-server

RUN bundle install

EXPOSE 5000