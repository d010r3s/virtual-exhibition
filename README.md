# Система управления виртуальной выставкой
simple database + gui (postgresql + pyqt5)
## Структура: 
#### Artists:
* artistid (int): pk художника
* name (str): имя
* country (str): страна
* yearsactive (str): годы деятельности
* biography (str): биография
#### Exhibits: 
* exhibitid (int): pk экспоната
* title (str): название экспоната
* artistid (str, Artists ref): ссылка на художника
* yearcreated (int): год создания
* style (str): стиль
* description (str): описание
#### Users: 
* userid (int): pk пользователя
* name (str): имя
* email (str): почта
* registrationcount (int, triggered): количество регистраций пользователя, триггерится Registration
#### Events: 
* eventid (int): pk события
* title (str): название
* date (yyyy-mm-dd): дата
* time (hh:mm): время начала
* location (str): место
* organizer (str): организатор
* participantcount (int, triggered): количество участников, триггерится Registration
#### Registrations:
* userid (int, Users ref): ссылка на пользователя
* eventid (int, Events ref): ссылка на событие 
* registrationid: pk регистрации
## Функционал:
#### Artists:
* Добавление записи
* Просмотр (обновление) таблицы
* Поиск по имени
* Изменение записи по id
* Удаление записи по id/имени
#### Exhibits:
* Добавление записи
* Просмотр (обновление) таблицы
* Поиск по названию
* Изменение записи по id
* Удаление записи по id/названию
#### Users:
* Добавление записи
* Просмотр (обновление) таблицы
* Поиск по имени
* Изменение записи по id
* Удаление записи по id/имени
#### Events:
* Добавление записи
* Просмотр (обновление) таблицы
* Поиск по названию
* Изменение записи по id
* Удаление записи по id/названию
#### Registrations:
* Добавление записи
* Просмотр (обновление) таблицы
* Поиск по id пользователя
* Изменение записи по id
* Удаление записи по id/названию
## Работа
#### Пользователь
exhibit_user (не суперюзер)
```bash
psql -U exhibit_user virtualexhibit
```
## Зависимости
* Exhibits / ArtistID (FK -> Artists)
* Registrations / UserID (FK -> Users)
* Registrations / EventID (FK -> Events)
* Users / registrationcount (триггер -> Registrations)
* Events / participationcount (триггер -> Registrations)
## Индексы 
* idx_users_name_trgm для поиска по столбцу Name в таблице Users
* idx_artists_name_trgm для поиска по столбцу Name в таблице Artists
* idx_exhibits_title_trgm для поиска по столбцу Title в таблице Exhibits
* idx_events_title_trgm для поиска по столбцу Title в таблице Events
#### Шрифт
https://fonts.google.com/specimen/Chakra+Petch
