# Система управления виртуальной выставкой
simple database + gui (postgresql + pyqt5)
## Структура: 
#### Artists
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
* registeredevents (str): события пользователя
* feedback (str): отзывы
#### Events: 
* eventid (int): pk события
* title (str): название
* date (yyyy-mm-dd): дата
* time (hh:mm): время начала
* location (str): место
* organizer (str): организатор
* participantcount (int, triggered): количество участников (триггерится таблицей пользователей)
## Работа
#### Пользователь
exhibit_user (не суперюзер)
```bash
psql -U exhibit_user virtualexhibit
```
