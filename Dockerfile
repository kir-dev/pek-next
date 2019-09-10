FROM ruby:2.4-alpine

ARG SECRET_KEY_BASE

# Install dependencies
RUN apk add --no-cache build-base postgresql-dev libssl1.1 tzdata imagemagick

RUN apk add --no-cache yarn
RUN export PATH="$PATH:/opt/yarn-[version]/bin"

RUN mkdir /pek-next
WORKDIR /pek-next

# Install dependencies
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install --deployment --without test development --retry 3

# Copy application
COPY . .

# Build assets
RUN bundle exec rake assets:precompile
