# PéK-Next

**The administration system for Schönherz Zoltán Student Hostel and [SVIE](http://svie.hu/)**

[![Build Status](https://travis-ci.org/kir-dev/pek-next.png?branch=master)](https://travis-ci.org/kir-dev/pek-next)
[![Code Climate](https://codeclimate.com/github/kir-dev/pek-next.png)](https://codeclimate.com/github/kir-dev/pek-next)
[![Dependency Status](https://gemnasium.com/kir-dev/pek-next.png)](https://gemnasium.com/kir-dev/pek-next)

## Running

**To run PéK you will need the following:**

Postgresql packages

```bash
$ sudo apt-get install postgres libpq-dev nodejs
```

Ruby 2.2.3 environment

```bash
$ \curl -sSL https://get.rvm.io | bash -s stable
$ rvm install 2.2.3
```

The source code and dependencies

```bash
$ git clone https://github.com/kir-dev/pek-next.git
$ cd pek-next
$ bundle install
```

Setting up the database

```bash
$ sudo su postgres
$ psql -c 'create user "pek-next" with superuser password '\''pek-next'\'';'
$ psql -c 'create database "pek-next";' -U postgres
$ psql -c 'create database "pek-next-test";' -U postgres
```

Creating the schema

```bash
$ rake db:structure:load
$ rake db:migrate
```

Create a `.env` file using `.env.example` and replace the values with real ones

**Starting the server**

```bash
$ rails s
```

And in a separate shell:

```bash
$ bundle exec sidekiq
```

**Running the tests**

```bash
$ rake test
```

by [Kir-Dev Team](http://kir-dev.sch.bme.hu/)
