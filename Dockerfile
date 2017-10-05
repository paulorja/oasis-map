FROM ruby:2.3.0

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN bundle install

EXPOSE 5000

CMD ["ruby", "run.rb"]