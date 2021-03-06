---
title: "GoLang Solutions"
description: "Решения типовых задач"
date: 2020-02-17
draft: false
enableToc: true
---

Ниже приведены мои варианты решения типовых задач, которые у меня возникали при разработке на golang.

## `func main()`

Пока я не нашел удобный способ тестировать `main()`, мой вариант - сократить эту функцию до одной строки и убрать ее из тестов.

Если репозиторий содержит бинарник с именем `APP`, его функция `main()` размещается в отдельном файле `cmd/APP/main.go` со следующим содержанием:

{{< source "static/src/golang/main.go" >}}

## log

* для случаев, отличных от примитивных, необходима возможность парсить логи приложения. Тут мой выбор - [structured logging](https://www.client9.com/structured-logging-in-golang/) и вариант его реализации - [zap](https://github.com/uber-go/zap)
* вместе с этим, зашивать конкретную имплементацию журналирования мне представляется не оптимальным, поэтому в пакетах использую [logr](github.com/go-logr/logr)
* в тестах, если надо собрать логи и потом проанализировать, я использую [genericr](github.com/wojas/genericr)

## config

Для конфигурации приложения наиболее характерный пример для меня - использование библиотеки, у которой есть свой конфиг, при обновлении которого я бы не хотел ничего менять в своем приложении. Я использую [go-flags](github.com/jessevdk/go-flags) и выглядит это так:

```go
type Config struct {
        Addr        string `long:"http_addr" default:"localhost:8080"  description:"Http listen address"`
        
        FS  lookupfs.Config `group:"Filesystem Options" namespace:"fs" env-namespace:"FS"`
        API procapi.Config  `group:"API Options" namespace:"api" env-namespace:"API"`
}
```

<!-- 
## errors

## tests

-->

## pg

Однажды, в [mqbridge](), мне понадобилось работать с каналом (`db.Listen(channel).Channel()`), для этого я выбрал [go-pg](github.com/go-pg/pg/v9). В остальных случаях использую [pgx](github.com/jackc/pgx/v4)

## embedding

Выбор пакета для меня определяется ответом на вопрос - "Нужна ли UnionFS" (т.е. возможность локальным файлом заменить какой-то файл из дистрибутива)

* если нужна - [go-imbed](https://github.com/growler/go-imbed)
* если нет - [parcello](github.com/phogolabs/parcello)

Начиная с go 1.16, первичный вариант решения - `embed`

## deploy

Тут все очевидно. Как автор [dcape](https://github.com/dopos/dcape), деплой всех своих приложений я делаю так. Другие варианты - это уже подарки тестовых задач. Добавлю, что, на мой взгляд, навык заворачивания приложения в docker я считаю полезным для программиста, а опыт управления kubernetes - нет. По двум причинам (k8s не единственный и не последний. Разве это не экспертиза уровня webpack?)

<!--
## DB app (pgmig)

### apisite
### pggrpc


## Dockerfile
```
# cache deps
go mod download

# краткий пример сборки проекта, чтобы не искать его в Makefile, не использует make
go build
```
-->