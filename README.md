# Система управления виртуальной выставкой искусств
simple database + gui (postgresql + pyqt5)
## Структура: 
#### Artists
artistid (int), name (str), country (str), yearsactive (str), biography (str)
#### Exhibits: 
[] exhibitid (int)
[] title (str)
[] artistid (str, Artists ref)
[] yearcreated (int)
[] style (str)
[] description (str)
#### Users: 
userid (int), name (str), email (str), registeredevents (str), feedback (str)
#### Events: 
eventid (int), title (str), date (yyyy-mm-dd), time (hh:mm), location (str), organizer (str), participantcount (int, triggered)
