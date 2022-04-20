---
title: "SQL Solutions"
description: "Решения для SQL"
date: 2020-02-17
draft: false
enableToc: true
---

В SQL мне наиболее интересна работа с хранимым кодом в PostgreSQL, но до того, чтобы собрать отдельный справочник, руки пока не доходят. Поэтому наполнение этой страницы еще в начальной стадии


## Пример теста

```sql
SAVEPOINT test_begin;
select pgmig.assert_count(1);
-- ----------------------------------------------------------------------------
SELECT pgmig.pkg_op_before('init', 'test_pgmig', 'v0.0', 'git');
SELECT pgmig.assert_eq('pkg_op_before'
, (SELECT jsonb_build_object('code',code,'version',version) FROM pgmig.pkg where code='test_pgmig')
, '{
        "version": "v0.0",
        "code": "test_pgmig"
   }'::jsonb
);
ROLLBACK TO SAVEPOINT test_begin;
```
## Мой топ в апреле 2022

```sql
select r.*
, abs.abs_rank
, cl.cl_rank
from results r
  left join (
    select
      id
    , row_number() over() as abs_rank
    from results where in_abs=1
  ) abs using(id)
  , lateral  (
      select * --coalesce(cl_rank,null) as cl_rank 
        from (
          select
            id
          , case when r.cl_next is null then 
              null
            else 
              row_number() over(partition by cl_next order by drv1_id)
            end as cl_rank
          from results r2 
          where
            r.cl_next is null or
            r.cl_next = any(r2.cls)
        ) cll
      where id = r.id
  ) cl
;
```

См. также

* [pgmig-sql](https://github.com/pgmig-sql/pgmig/blob/master/50_pkg.test.sql)
* [pomasql-md](https://github.com/pomasql/enfist/blob/master/90_test.md)
* [pgmig](https://github.com/LeKovr/pgws/blob/master/ws/eg/pkg/app_sample/sql/03_app_sample/90_test.sql)

