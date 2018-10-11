FROM ruby:2.3.1

RUN mkdir -p /oasis-map
WORKDIR /oasis-map

COPY . /oasis-map

RUN bundle install

EXPOSE 5000