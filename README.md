# PéK-Next

**The administration system for Schönherz Zoltán Student Hostel and [SVIE](http://svie.hu/)**

[![Build Status](https://travis-ci.org/kir-dev/pek-next.png?branch=master)](https://travis-ci.org/kir-dev/pek-next)
[![Code Climate](https://codeclimate.com/github/kir-dev/pek-next.png)](https://codeclimate.com/github/kir-dev/pek-next)
[![Dependency Status](https://gemnasium.com/kir-dev/pek-next.png)](https://gemnasium.com/kir-dev/pek-next)

## Running

**To run PéK you will need the following:**

###### Postgresql packages

```bash
$ sudo apt-get install postgresql libpq-dev nodejs
```

###### Ruby 2.2.3 environment

```bash
$ \curl -sSL https://get.rvm.io | bash -s stable
$ rvm install 2.2.3
```

###### The source code and dependencies

```bash
$ git clone https://github.com/kir-dev/pek-next.git
$ cd pek-next
$ gem install bundler
$ bundle install
```

Create a `.env` file using `.env.example` and replace the values with real ones

###### Setting up the database

```bash
$ sudo su postgres
$ psql -c 'create user "pek-next" with superuser password '\''pek-next'\'';'
$ psql -c 'create database "pek-next";' -U postgres
$ psql -c 'create database "pek-next-test";' -U postgres
```

###### Creating the schema

_As your own user_

```bash
$ rake db:structure:load
$ rake db:migrate
```

###### If you start developing with a clean database

```bash
$ rake db:seed
```

**Starting the server**

```bash
$ rails s
```

_And in a separate shell:_

```bash
$ bundle exec sidekiq
```

**Running the tests**

```bash
$ rake test
```

### Problems you may encounter and the solutions

##### Ruby cannot build the native extensions

```bash
$ sudo apt-get install ruby-dev
```

##### After setting from RVM the ruby version is still not correct

_RVM sometimes needs an interactive shell_

```bash
$ bash --login
```

by [Kir-Dev Team](http://kir-dev.sch.bme.hu/)
