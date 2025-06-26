#!/bin/bash

# Параметры подключения к PostgreSQL
HOST="localhost"
PORT="5432"
DB_NAME=""
USER=""

# SQL запрос для выполнения
SQL_QUERY="COPY (
    WITH dir AS (SELECT current_setting('data_directory') || '/base/pgsql_tmp' dir),
    ls AS (SELECT *, pg_ls_dir(dir) fn FROM dir),
    tmp AS (
        SELECT *, regexp_replace(fn, '^pgsql_tmp(\d+).*$', '\1')::integer pid, 
        (pg_stat_file(dir || '/' || fn)).*
        FROM ls
    )
    SELECT dir || '/' || fn
    FROM tmp
    LEFT JOIN pg_stat_activity sa USING(pid)
    WHERE sa IS NOT DISTINCT FROM NULL
) TO '/tmp/output.csv' WITH CSV;"

# Выполнение SQL-запроса
PGPASSWORD=$(cat /home/postgres/.pgpass) psql -h $HOST -p $PORT -U $USER -d $DB_NAME -c "$SQL_QUERY"

# Удаление файлов из списка
cat /tmp/output.csv | while read f; do 
  rm "$f";
 done

# Удаление output.csv
rm -f /tmp/output.csv
