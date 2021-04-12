---
title: "webtail"
date: 2020-01-30T00:38:25+09:00
description: Публикация изменений (журнальных) файлов через websocket
draft: false
enableToc: false
weight: 6
---

 Github |  [LeKovr/webtail](https://github.com/LeKovr/webtail)
 -- | --
 Назначение | Публикация изменений (журнальных) файлов через websocket
 Docker | [ghcr.io/lekovr/webtail](https://github.com/users/LeKovr/packages/container/package/webtail)

**webtail** - это веб-сервис и golang-пакет, предназначенные для публикации изменений постоянно дополняемых файлов (например - журналов) по протоколу websocket с доступом через браузер.

Сервис **webtail** использован в составе первой версии **dcape** для доступа к журналам развертывания приложений, в версии 2 эта информация доступна [через portainer](https://dopos.github.io/dcape/baseapps/portainer/).

В начале 2021г у меня появилась возможность сделать рефакторинг исходного кода, доделать документацию и довести покрытие тестами до 77%, это пока удалось только для этого "вторичного pet-проекта".
