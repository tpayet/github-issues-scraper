FROM ruby:2.7.1-alpine3.11

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENTRYPOINT ["ruby", "app.rb"]

