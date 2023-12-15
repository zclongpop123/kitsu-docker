<p align="center">
  <img src="https://www.cg-wire.com/_nuxt/logo-kitsu.de716c4b.png" alt="image" width="150" height="auto">
</p>

Better. Faster. Together.
=
Kitsu is a collaboration platform for Animation and VFX studios. It empowers your teams to deliver better content faster.
---
> https://www.cg-wire.com/kitsu

#### 1. Create Database
```bash
su - postgres
```
```bash
psql
```
```sql
CREATE DATABASE kitsu_db;
```
```sql
CREATE ROLE kitsu_db_user;
```
```sql
GRANT ALL ON DATABASE kitsu_db TO kitsu_db_user;
```
```bash
\password kitsu_db_user;
```

#### 2. Initialize Database
```bash
zou init-db
```
```bash
zou create-admin
```
