# PéK-Next

**The administration system for Schönherz Student Hostel and [SVIE](https://svie.hu/)**

[![Build Status](https://travis-ci.org/kir-dev/pek-next.png?branch=master)](https://travis-ci.org/kir-dev/pek-next)
[![Code Climate](https://codeclimate.com/github/kir-dev/pek-next.png)](https://codeclimate.com/github/kir-dev/pek-next)
[![Dependency Status](https://gemnasium.com/kir-dev/pek-next.png)](https://gemnasium.com/kir-dev/pek-next)

## Requirements

- Ruby 2.5.7
- Postgresql 9.6
- Node (asset compiling)
- Redis (optional)

or

- Docker

## Installing requirements

### Debian derivatives

###### Packages

```bash
# Redis is optional
sudo apt install postgresql-9.6 libpq-dev nodejs redis-server
```

###### Ruby 2.5.7

Use [asdf](https://asdf-vm.github.io/asdf/#/core-manage-asdf-vm) with [ruby plugin](https://github.com/asdf-vm/asdf-ruby) or [rbenv](https://github.com/rbenv/rbenv). Install Ruby 2.5.7 and set executable version. You can check current ruby version with `ruby -v`

### MacOS

###### Brew

Easiest way to install [brew](https://brew.sh), then install required packages.

```bash
# Redis is optional
brew install asdf postgresql@9.6 redis
brew services start postgresql@9.6
brew services start redis
```

###### Ruby 2.5.7 and Node

Add [ruby](https://github.com/asdf-vm/asdf-ruby) and [node](https://github.com/asdf-vm/asdf-nodejs) plugin to asdf. Install Ruby 2.5.7 and set executable version. You can check current ruby version with `ruby -v`. Install node too.

## Setting up

###### The source code and dependencies

```bash
git clone https://github.com/kir-dev/pek-next.git
cd pek-next
gem install bundler
bundle install
```

###### Environment

Create a `.env` file using `.env.example` and replace the values with real ones.

###### The database

```bash
sudo su postgres
psql -c 'create user "pek-next" with superuser password '\''pek-next'\'';'
```

###### Init database

_As your own user_

```bash
rake db:setup
```

## Running

###### The server

```bash
rails s
```

###### Worker (optional, requires redis)

```bash
bundle exec sidekiq
```

###### The tests (of course)

```bash
rake test
```

## Deployment

Easiest way for deployment is docker-compose.

Copy `.env` from `.env.example`, add `APP_ID` and `APP_SECRET` according to auth.sch and generate a `SECRET_KEY_BASE` using `bundle exec rake secret`.

Then run the following commands:

```bash
# These volumes are not necessary and could be removed from docker-compose, but a named volume easier to find later on
docker volume create pek_public
docker volume create pek_database
docker-compose up --build
```

To deploy the application in **staging** environment use the following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose.staging.yml up -d --build
```

After creating, while the containers are running run the following commands:

```bash
# This is only necessary at new setups
docker-compose run web bash -c "bundle exec rake db:setup"

# This is only necessary after pending migrations
docker-compose run web bash -c "bundle exec rake db:migrate"

# This is required at new setups and after changing in assets
docker-compose run web bash -c "bundle exec rake assets:precompile"
```

### In Production

Add the following Nginx configuration setting for the server block.
This enables the rails server to see the clients original ip, not just the reverse proxy's ip.
The client's ip is required to authenticate users for the AuthSchServicesController.

```shell
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

## Maintenance tasks

Be sure to make regular backups in prod.

To **create a database** dump, use the following commands:

```bash
# open a session to the postgres container
docker-compose exec postgres bash

# create the database dump in the postgres container (use your current date),then exit
pg_dump -U postgres -Fc pek-next > /tmp/pek-next-production-db-2022-12-04.dump
exit

# copy the database dump from the container to the host machine
docker cp pek-next_postgres_1:/tmp/pek-next-production-db-2022-12-04.dump ~/db-dumps
```
To load a previously created database dump, use the following commands:
```bash
# copy the dump from the host to the postgres container
docker cp ~/db-dumps/pek-next-production-db-2022-12-04.dump pek-next_postgres_1:/tmp

# open the postgres container and load the database dump 
docker-compose exec postgres bash
pg_restore -U postgres -d pek-next /tmp/pek-next-production-db-2022-12-04.dump
```

## Problems you may encounter and the solutions

###### Ruby cannot build the native extensions

```bash
sudo apt install ruby-dev
```

###### Rbenv install only gives ruby-build usage instructions

```bash
rbenv install -v 2.5.7
```

###### Rbenv doesn't modify your ruby version

```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

###### Rails command is not recognized after install

_Restart your terminal_

by [Kir-Dev Team](https://kir-dev.hu/)

### Special thanks for

[![Rollbar](public/img/rollbar.png)](https://rollbar.com/)
