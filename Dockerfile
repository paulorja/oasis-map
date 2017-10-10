FROM ruby:2.3.0

RUN mkdir -p /oasis-server
WORKDIR /oasis-server

COPY . /oasis-server

RUN bundle install

EXPOSE 5000

CMD ["ruby", "run.rb"]
