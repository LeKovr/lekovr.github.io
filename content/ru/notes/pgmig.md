---
title: "PgSQL: git-миграции"
description: "Контроль версий для SQL"
date: 2022-12-16
draft: false
enableToc: true
---

# PgSQL: git-миграции

**Статус документа: черновик**

## Задача

Найти способ разместить хранимый код в файлах так, чтобы его изменения были доступны через git, т.е. придумать миграцию, в которой изменения как можно большей части SQL будут в тех же файлах

### Условия

1. речь идет, прежде всего, о PostgreSQL
2. конструкция `CREATE OR REPLACE {FUNCTION|VIEW}` позволяет обновить код без потери функциональности кода, использующего эти объекты
3. тест хранимого кода внутри транзакции, вызвав EXCEPTION, отменяет все изменения

## Базовые идеи

1. файлы с миграциями разделить на 2 группы 
1.1. создание таблиц с важными данными, которые не должны удаляться без запроса на удаление схемы
1.2. вспомогательные объекты, которые могут быть пересозданы внутри транзакции (например - справочники)
2. SQL-запросы поместить в файлы, которые исполняются
2.1. однократно (создание таблиц и их изменение)
2.2. при каждой миграции (создание/обновление функций и представлений + тесты)

## Вариант решения

1. разбить БД на схемы данных, инкапсулирующих связность (чтобы миграция затрагивала минимум схем)
2. в каждой схеме выделить файлы, содержащие только SQL из п. 2.1 - у них маска *_once.sql, при выполнении в БД сохраняется их контрольная сумма (если изменятся - будет предупреждение или прерывание миграции)
3. зафиксировать имя, которое при сортировке файлов разделит список на 2 части
3.1. корневая - когда надо удалить всю схему
3.2. вторичная - то, что можно удалить без потери данных корневой
4. для каждого файла предоставить ф-ю с аргументом - SQL удаления созданных объектов, чтобы его сохранили и выполнили по команде "удалить файл"

## Какие плюсы

1. Для SQL-разработчиков получим обычную среду разработки

## В чем сложности


## См. Также

### Мое

* pgrpc
* pomasql
* pgmig

### Чужое

* https://habrahabr.ru/post/121265/
* https://habrahabr.ru/post/121909/
* https://habrahabr.ru/post/124480/
* https://habrahabr.ru/post/124627/