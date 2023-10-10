---
title: "Про курс по Pg"
description: "Что бы я включил в курс о Postgresql"
date: 2020-10-10
draft: false
enableToc: true
---

# Что бы я включил в курс о Postgresql

Столкнувишь с вопросом "Что бы Вы сказали о нашем курсе по Postgresql?", я пришел к выводу, что будет правильно сформулировать мой ответ как ТЗ автору такого курса. Далее - оно.

## 1. База

Базовая документация Postgresql - https://www.postgresql.org/docs/
Ее версия на русском - https://postgrespro.ru/docs, но этот перевод предназначен "исключительно для использования в личных и/или некоммерческих целях", поэтому, если курс - коммерческий, на перевод ссылаться не надо (но слушателям стоит о нем знать).

_Обратная связь_

1. Два вида работ с БД - это разработка и администрирование. Будет полезно сразу узнать, зачем пришли слушатели, тут бы помогла анкета из десятка пунктов, чтобы понять, что именно хочет получить текущая группа
2. ознакомиться с документацией и пройти опрос "понятно/надо пояснять/иное" - это позволит
    - понять уровень группы
    - отсечь очевидные темы
    - сосредоточиться на нужном

## 2. Введение

Pg - серверное приложение, для работы с ним нужен клиент. Варианты клиентов:

- psql - консольный, базовый, идет в составе дистрибутива
- <https://dbeaver.io/>
- <https://www.pgadmin.org/>
- <https://sosedoff.github.io/pgweb/>

С сервером Pg можно поработать без его установки, варианты:

- https://uibakery.io/sql-playground - доступ через клиент, возможно несколько коннектов
- https://www.db-fiddle.com/ - www
- https://extendsclass.com/postgresql-online.html - www

_Обратная связь_

1. опрос - какой клиент предпочтительнее вам, чтобы мы его скриншоты вам на занятии показывали
2. опрос - как с серверами, что удобнее - ссылки выше/на своем компе/VDS с linux/иное

## 3. Основная часть

Для закрепления привязки курса к Базовой документации, темы я бы оформил как ссылки на ее разделы.

### [5. Data Definition](https://www.postgresql.org/docs/current/ddl.html)

Тут стоит обратить внимание на `CREATE UNLOGGED TABLE`, пример - [PostgreSQL as a Cache](https://martinheinz.dev/blog/105)

### [9. Functions and Operators](https://www.postgresql.org/docs/current/functions.html)

Тут стоит обратить внимание на

* [9.12. Network Address Functions and Operators](https://www.postgresql.org/docs/current/functions-net.html)
* [9.19. Array Functions and Operators](https://www.postgresql.org/docs/current/functions-array.html), в частности - `unnest`

но наиболее интересен блок

[9.16. JSON Functions and Operators](https://www.postgresql.org/docs/current/functions-json.html)
в чем фишка (от 2017г) - [Postgres vs Mongo](https://www.youtube.com/watch?v=SNzOZKvFZ68)

### [13. Concurrency Control](https://www.postgresql.org/docs/current/mvcc.html)

1. чаще всего используется `Read Committed`, стоит добавить задачи, для которых подошли бы другие уровни
2. для отработки примеров подойдет https://uibakery.io/sql-playground 

### [14.1. Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)

* https://explain.tensor.ru/
* [Как мы ускорили выполнение запросов PostgreSQL в 100 раз](https://habr.com/ru/companies/cloud_mts/articles/659455/)

### [16. Installation from Binaries](https://www.postgresql.org/docs/current/install-binaries.html)

В базовой доке нет ничего про облака или докер, про облака бы пригодился список вариантов с указанием текущих цен, про докер может хватить <https://hub.docker.com/_/postgres>

_Обратная связь_

Опрос - какова для вас сложность варианта

- пакеты
- docker

PS. Про обновление версии - уже есть простое решение (https://github.com/tianon/docker-postgres-upgrade), стоит его разобрать.

### [31. Logical Replication](https://www.postgresql.org/docs/current/logical-replication.html)

Вполне можно в рамках одного занятия реализовать N-мультимастер на логической репликации с хэш-функцией.

### [38.7. Function Volatility Categories](https://www.postgresql.org/docs/current/xfunc-volatility.html)

Как описать функцию, которую можно запустить на реплике (потому что она не `VOLATILE`)

### [38.17. Packaging Related Objects into an Extension](https://www.postgresql.org/docs/current/extend-extensions.html)

* https://github.com/citusdata/citus в т.ч. [citus_columnar](https://github.com/citusdata/citus/issues/7189)
* https://tembo.io/blog/postgres-extension-in-rust-pgmq/

### [40. Event Triggers](https://www.postgresql.org/docs/current/event-triggers.html)

Это про DDL-триггеры, хорошо бы добавить примеры (при изменении хранимки положить ее в гит?)

### [42. Procedural Languages](https://www.postgresql.org/docs/current/xplang.html)

* https://github.com/plv8/plv8

## Дополнения

Проекты за рамками курса, которые, возможно, стоит упомянуть

* https://github.com/getredash/redash
* https://github.com/PostgREST/postgrest
* https://github.com/message-db/message-db
* https://github.com/lesovsky/pgcenter
* https://github.com/NikolayS/postgres_dba
* https://gitlab.com/postgres-ai/postgres-checkup