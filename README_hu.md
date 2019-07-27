# PéK-Next

**A Schönherz Kollégium és a [SVIE](http://svie.hu/) nyilvántartó rendszere**

[![Build Status](https://travis-ci.org/kir-dev/pek-next.png?branch=master)](https://travis-ci.org/kir-dev/pek-next)
[![Code Climate](https://codeclimate.com/github/kir-dev/pek-next.png)](https://codeclimate.com/github/kir-dev/pek-next)
[![Dependency Status](https://gemnasium.com/kir-dev/pek-next.png)](https://gemnasium.com/kir-dev/pek-next)

## Rendszerkövetelmények

- Ruby 2.4.2
- Postgresql 9.6
- Node (asset fordítás)
- Redis (választható)

vagy

- Docker

## Telepítési függőségek

### Debian alapú rendszerekhez

###### Csomagok

```bash
# A Redis választható
sudo apt install postgresql-9.6 libpq-dev nodejs redis-server
```

###### Ruby 2.4.2

[Asdf](https://asdf-vm.github.io/asdf/#/core-manage-asdf-vm) használata ajánloatt [ruby pluginnel](https://github.com/asdf-vm/asdf-ruby) vagy [rbenv](https://github.com/rbenv/rbenv) önmagában. Telepítsd a Ruby 2.4.2-t, majd állítsd be a futtatott verziószámot. Az éppen futó verziót a `ruby -v` paranccsal tudod lekérdezni.

### MacOS

###### Brew

A legegszerűbb, ha telepítjük a [brew-t](https://brew.sh), majd ezzel a további függőségeket.

```bash
# A Redis választható
brew install asdf postgresql@9.6 redis
brew services start postgresql@9.6
brew services start redis
```

###### Ruby 2.4.2 és Node

Add hozzá a [ruby](https://github.com/asdf-vm/asdf-ruby) és [node](https://github.com/asdf-vm/asdf-nodejs) bővítményeket az asdfhez. Telepítsd a Ruby 2.4.2-t, majd állítsd be a futtatott verziószámot. Az éppen futó verziót a `ruby -v` paranccsal tudod lekérdezni.

## Beállítás

###### Forráskód és függőségek

```bash
git clone https://github.com/kir-dev/pek-next.git
cd pek-next
gem install bundler
bundle install
```

###### Futtatókörnyezet

Az éles értékek behelyettesítésével hozd létre a `.env` fájlt a `.env.example` alapján.

###### Adatbázis

```bash
sudo su postgres
psql -c 'create user "pek-next" with superuser password '\''pek-next'\'';'
```

###### Adatbázisséma telepítése

_Saját felhasználóként_

```bash
rake db:setup
```

## Futtatás

###### Szerver

```bash
rails s
```

###### Feldolgozó (választható, redis-t követel)

```bash
bundle exec sidekiq
```

###### Tesztek futtatása

```bash
rake test
```

## Telepítés

A legegyszerűbb mód a docker-compose használata.

Az éles értékek behelyettesítésével hozd létre a `.env` fájlt a `.env.example` alapján. Az `APP_ID` és `APP_SECRET` változót az auth.sch-ról kapott token alapján vedd fel; a `SECRET_KEY_BASE`-t a `bundle exec rake secret` parancs kimenetével tudod feltölteni.

Futtasd a következő prancsokat:

```bash
# Nem szükséges ezeket a köteteket név szerint felvenni, így viszont könnyebb lehet hivatkozni rájuk később.
docker volume create pek_public
docker volume create pek_database
docker-compose up --build
```

Miután létrejöttek, add ki az alábbi parancsokat, miközben futnak a szükséges háttérszolgáltatások, konténerek:

```bash
# Ez csak akkor szükséges, ha először telepíted a PéK-et
docker-compose run web bash -c "bundle exec rake db:setup"

# Csak akkor szükséges ha van olyan migráció, ami még nem futott le
docker-compose run web bash -c "bundle exec rake db:migrate"

# Ez csak új telepítésnél és asset váltáskor szükséges
docker-compose run web bash -c "bundle exec rake assets:precompile"
```

## Ismert nehézségek és megoldások

###### A Ruby nem tud natív kiegészítőket telepíteni

```bash
sudo apt install ruby-dev
```

###### Rbenv install only gives ruby-build usage instructions

```bash
rbenv install -v 2.4.2
```

###### Az Rbenv nem befolyásolja a Ruby verziót

```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
```

###### A telepítés ellenére nem találja a shell a rails parancsot

_Indítsd újra a terminálod_

Készítette: [Kir-Dev Team](http://kir-dev.sch.bme.hu/)

### Külön köszönet:
[![Rollbar](public/img/rollbar.png)](https://rollbar.com/)
