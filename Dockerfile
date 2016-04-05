FROM ruby:2.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /pek-next
WORKDIR /pek-next
ADD Gemfile /pek-next/Gemfile
ADD Gemfile.lock /pek-next/Gemfile.lock
RUN bundle install
ADD . /pek-next
