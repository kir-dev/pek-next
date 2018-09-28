# PéK-Next

**The administration system for Schönherz Zoltán Student Hostel and [SVIE](http://svie.hu/)**

[![Build Status](https://travis-ci.org/kir-dev/pek-next.png?branch=master)](https://travis-ci.org/kir-dev/pek-next)
[![Code Climate](https://codeclimate.com/github/kir-dev/pek-next.png)](https://codeclimate.com/github/kir-dev/pek-next)
[![Dependency Status](https://gemnasium.com/kir-dev/pek-next.png)](https://gemnasium.com/kir-dev/pek-next)

[![](https://codescene.io/projects/3358/status.svg) Get more details at **codescene.io**.](https://codescene.io/projects/3358/jobs/latest-successful/results)

[![codebeat badge](https://codebeat.co/badges/55f292f8-9e63-41f1-9fbd-68e15ecfcdaa)](https://codebeat.co/projects/github-com-kir-dev-pek-next-master)

## Running

**To run PéK you will need the following:**

###### Postgresql packages

```bash
$ sudo apt-get install postgresql libpq-dev nodejs
```

###### Ruby 2.4.2 environment

```bash
$ sudo apt-get install rbenv
$ mkdir -p "$(rbenv root)"/plugins
$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
$ rbenv install 2.4.2
$ rbenv global 2.4.2
```

Check current ruby version with `ruby -v`

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
```

###### Creating a clean database

_As your own user_

```bash
$ rake db:setup
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

##### Rbenv install only gives ruby-build usage instructions

```bash
$ rbenv install -v 2.4.2
```

##### Rbenv doesn't modify your ruby version

```bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
$ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
$ source ~/.bashrc
```

##### Rails command is not recognised after install

_Restart your terminal_

by [Kir-Dev Team](http://kir-dev.sch.bme.hu/)

### Special thanks for
[![Rollbar](public/img/rollbar.png)](https://rollbar.com/)
