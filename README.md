<p align="center">
  <img src="https://zou.cg-wire.com/kitsu.png" alt="image" width="150" height="auto">
</p>

Better. Faster. Together.
=
Kitsu is a collaboration platform for Animation and VFX studios. It empowers your teams to deliver better content faster.
---
> https://www.cg-wire.com/kitsu

#### 1. Build image
```bash
docker build -t kitsu .
```

#### 2. Create Database
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

#### 3. Initialize Database
```bash
zou init-db
```
```bash
zou create-admin
```
