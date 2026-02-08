---
title: "Про фреймворки"
description: "Gin и GRPC"
date: 2025-08-26
draft: false
enableToc: true
---

При всей любви к изобилию доступных библиотек, в последнее время я предпочитаю минимизировать количество зависимостей.

Основные причины - чем больше зависимостей, тем 
1. чаще придется их обновлять (gin в свое время мне этим делом даже какую-то мышцу прокачал, наверное)
2. больше кода надо контролировать

Мой кейс по уменьшению зависимостей

1. API описываем в .proto - это позволяет использовать [gogens](https://github.com/LeKovr/gogens/blob/v1/Dockerfile)
2. Применяем [protoc-gen-gohttp](github.com/nametake/protoc-gen-gohttp) - получаем обвязку для JSON и protobuf
3. Добавляем [go-kit/server](https://github.com/LeKovr/go-kit/tree/main/server) - получаем каркас сервера.

