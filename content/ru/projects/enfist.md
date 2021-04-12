---
title: "enfist"
date: 2020-01-30T00:38:25+09:00
description: хранилище файлов конфигурации в postgresql с доступом через браузер и АПИ
draft: false
enableToc: false
weight: 5
---

 Github |  [enfist](https://github.com/apisite/app-enfist)
 -- | --
 Назначение | хранилище файлов конфигурации в postgresql с доступом через браузер и АПИ
 Использование | [в составе dcape](https://dopos.github.io/dcape/baseapps/enfist/)
 Docker | [apisite/enfist](https://hub.docker.com/r/apisite/enfist)

Сервис **enfist** создавался как составная часть проекта [dcape](https://dopos.github.io/dcape/), включен в его состав в 2018м году, и с того времени находится в продакшене. Описание работы с **enfist** включено в [документацию dcape](https://dopos.github.io/dcape/baseapps/enfist/).

Если коротко, то приложение позволяет работать со списком и содержимым файлов конфигурации через web-интерфейс и через API, при этом документация к API генерируется программно.

Если посмотреть на [исходный код](https://github.com/apisite/app-enfist), то можно увидеть там только `SQL`, `js` и статику, которые реализуют бизнес-логику (модуль [pomasql/enfist](https://github.com/pomasql/enfist)) и интерфейс (в `static/` и `tmpl/`). Для того, чтобы из этого получить работающий сервис, [используется](https://github.com/apisite/app-enfist/blob/master/Dockerfile#L1) фреймфорк [apisite](https://github.com/apisite/apisite).

Т.о., проект решает две задачи

* функциональную - сервис хранения конфигураций для CI/CD системы
* демонстрационную - как пример использующего БД golang-сервиса с API, для создания которого не понадобилось писать код на golang
