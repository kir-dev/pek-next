FROM ruby:2.4
RUN apt-get update -qq &&\
    apt-get install -y build-essential libpq-dev nodejs libssl1.0-dev \
    postgresql-client imagemagick apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install yarn

RUN export PATH="$PATH:/opt/yarn-[version]/bin"

RUN mkdir /pek-next
WORKDIR /pek-next

# Install dependencies
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

# Copy application
COPY . .
