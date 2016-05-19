# Running
- install postgresql (including the headers, `postgresql-server-dev` on ubuntu)
- create a user and a database
- run the following on your test database: `CREATE SEQUENCE users_usr_id_seq;`
- import the users table
- update the database and credentials in `config/database.yml`
