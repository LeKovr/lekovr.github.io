---
title: "Хранимки и RPC"
description: "Взгляд на RPC со стороны хранимок"
date: 2022-12-14
draft: false
enableToc: true
---
# Взгляд на RPC со стороны хранимок

## Термины и определения {#terms}

Во избежание разночтений, приведу определения используемых в тексте сокращений:

Хранимка
: "Хранимая процедура или функция (stored procedure, function). Данные объекты БД пишутся на языке процедурного расширения языка SQL, который дополняет язык SQL такими управляющими структурами языка высокого уровня, как ветвления и циклы, и позволяет реализовать любые алгоритмы обработки данных. Хранимый код постоянно хранится на сервере и выполняется по запросу на его запуск из приложений клиентов" [^1].

API
: описание способов взаимодействия одной компьютерной программы с другими [^2].

RPC API
: "Удалённый вызов процедур... класс технологий, позволяющих программам вызывать функции или процедуры в другом адресном пространстве" [^3].

## Предисловие {#intro}

Когда идею совмещения HTML и PHP в одном файле начали считать неправильной, я был этому рад, т.к. считаю, что такое совмещение:
1. Требует переключать контекст между разными стеками - декларативным и функциональным.
2. Размазывает требования к квалификации разработчика - уже недостаточно разбираться в одной из двух технологий.

Когда идея микросервисов начала принимать форму "каждому сервису - свою БД", я был удивлен и опечален тем, что выводы из истории HTML+PHP, очевидные для меня, не попали в тренд.

В контексте "БД" я рассматриваю только СУБД, которые поддерживают хранимый код, поэтому выводы мои были такие:

1. SQL и ЯП - разные контексты и первый шаг распила монолита - это поместить их в разные сервисы.
2. Если предоставить ЯП некий АПИ по работе с БД, то этот ЯП может быть любым. Плюс заменить БД тоже будет проще.
3. Если набрать команду, которая отвечает только за данные и операции с ними, предоставляя АПИ, то.. по мне так это здорово, но это не в тренде и опенсорсных решений для такой команды нет (см. ниже про миграции).

Далее - о том, как я вижу RPC с точки зрения моего опыта в хранимках.

## Описание АПИ {#api}

АПИ - это набор сервисов, состоящих из методов. Для каждого метода задается сигнатура - имя, аргументы, результат и описание их структур.

Для АПИ результат метода желательно иметь простым (скаляр, структура или массив структур), но в самой БД связи могут быть сложнее (не все поля из N таблиц, а некое, адекватное задаче, представление).

Из этого я сделал вывод, что первичной должна быть схема данных, по которой для каждого метода формируются структуры, которые уже могут быть использованы в описании АПИ.

На этом этапе получается такой план:

1. Описать предметную область.
2. Спроектировать структуры данных.
3. Описать методы и их сигнатуры.
4. Загрузить это в БД и проверить корректностью
5. По содержимому БД сгенерить описание АПИ (не парсить исходники, а взять метаданные из БД).
6. Вот тут распараллелим - БД:реализация хранимок и тестов, Клиенты:реализация.

> На текущий момент я под термином "описание АПИ" понимаю protobuf.

## Генерация кода {#gen}

Итак, у нас есть .proto и по нему мы можем сгенерить:

1. Интерфейсы для сервиса (например - на golang).
2. Клиента (на поддерживаемых генераторами ЯП).
3. Спецификацию OpenAPI (со всеми вытекающими).

Но ведь сервис просто будет вызывать хранимки, чего не хватает для его генерации?

* ACL (права доступа).
* Cache (мы работаем с БД, тут это - важно).

Есть варианты:

1. Протащить эти два пункта через спецификацию и сразу генерить сервис, который вызывает хранимку на SQL.
2. Описать эти метаданные в БД и для генерации сервиса сделать к ней нужные запросы.

На мой взгляд, если в protobuf найдется решение - надо выбрать его, иначе придется сочинить собственный стандарт и там выбрать.

## Хранимки {#stored}

Программный код (функции и процедуры), размещаемый в БД и выполняемый  Под этим термином 
В чем я вижу их плюсы:

1. Вся логика работы с БД инкапсулируется внутри нее, а клиентам доступен только некий АПИ.
2. Взаимодействие приложения с БД сводится к запросам вида `select a,b from func(x,y)`.
3. Даже парсить ничего не надо - уже все есть в метаданных БД, и сигнатуры и комментарии/документация.

### Миграции {#mig}

Насколько мне известно, основной вариант миграций в настоящее время - это оформить в один или несколько файлов все изменения БД текущей миграции. В частности, если надо поменять код хранимки или представления - он дублируется в новом файле с исправлениями (привет, git).

Однако, конструкция `CREATE OR REPLACE {FUNCTION|VIEW}` позволяет обновить код в работающей системе. А если обернуть ее в транзакцию и добавить тесты - то обновление сработает только при успехе тестов.

Если мы уберем из рассмотрения системы миграции, которые этот факт не учитывают, что останется?
Мой ответ - написать свою (к слову, мой вариант решения этой задачи в продакшене уже 10 лет).

### Тесты {#testing}

Транзакция, в которой производится миграция, может быть дополнена тестами в виде SQL-запросов, которые при ошибке, сразу или в конце тестов, вызывают EXCEPTION и отменяют все изменения БД. 

## FAQ

### Почему protobuf, а не OpenAPI? {#q-proto}

REST - это для HTTP, круг моих задач шире (там нет PUT/DELETE/etc) и мне нужен RPC. А для HTTP я бы предпочел ReadOnly запросы оформить в GET, остальные в POST. И в обоих случаях имя метода хотелось бы видеть в access.log.

### Где взять спецов по БД и хранимкам? {#q-job}

Такие люди есть, но рынок их спрятал за "золотой забор". Все же хотели "SQL+PHP/Ruby/JS/Java/GO/Rust". В итоге спецы по "вечному" начали размываться и тратить время на "приходящее". И рынок за это заплатит, я считаю. 

С другой стороны, "спецом по БД" принято считать и DBA, но он отвечает за администрирование, для него разработка вторична и это добавляет сложность в позиционирование и поиск персонала.

Т.о., корректный заголовок вакансии мог бы выглядеть так: "Разработчик SQL/PlPgSQL (не DBA)".

### Что-то кроме PostgreSQL? {#q-nonpg}

Сомневаюсь. Я в прошлом веке к нему пришел, с тех пор стараюсь мониторить альтернативы, но ничего лучше не видел. Хотя, на современный Линтер надо бы глянуть.

## Ссылки по теме {#links}

### Использованная литература {#links-internal}

[^1]: [Хелпикс: Основные объекты БД](https://helpiks.org/4-104016.html).
[^2]: [Википедия: API](https://ru.wikipedia.org/wiki/API).
[^3]: [Википедия: Удалённый вызов процедур](https://ru.wikipedia.org/wiki/Удалённый_вызов_процедур).

### См. также {#links-also}

* [Habr: Вред хранимых процедур](https://habr.com/ru/company/ruvds/blog/517302/).
* [Goose: Ad-hoc migrations with no versioning](https://pressly.github.io/goose/blog/2021/no-version-migrations/).
