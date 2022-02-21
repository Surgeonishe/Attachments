
Процедура ПередЗаписью ( Отказ )

	Если ( ОбменДанными.Загрузка ) Тогда
		Возврат;
	КонецЕсли;
	Отказ = проверитьВыбранныеПрава ();
	Если ( Отказ ) Тогда
		Возврат;		
	КонецЕсли;
	Если ( НЕ ЗначениеЗаполнено ( ИдентификаторПользователяИБ ) ) Тогда
		создатьПользователяИБ ();
	КонецЕсли;

КонецПроцедуры

Функция проверитьВыбранныеПрава ()
	
	ошибка = Ложь;
	колвоВыбранных = 0;
	Для Каждого строкаТЧ Из Роли Цикл
		Если ( строкаТЧ.Использование ) Тогда
			колвоВыбранных = колвоВыбранных + 1;
			Если ( строкаТЧ.Роль = "Пользователь" И Контрагент = Справочники.Контрагенты.ПустаяСсылка () ) Тогда
				ошибка = Истина;
				Сообщить ( "Выбрана роль ""Пользователь"". Необходимо выбрать контрагента!", СтатусСообщения.Важное );
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если ( НЕ ошибка И колвоВыбранных = 0 ) Тогда
		Сообщить ( "Не выбрана ни одна роль!", СтатусСообщения.Важное );
		ошибка = Истина;
	КонецЕсли;		
	Возврат ошибка

КонецФункции

Процедура создатьПользователяИБ ()
	
	пользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени ( Наименование );
	Если ( пользовательИБ = Неопределено ) Тогда
		пользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя ();		
	КонецЕсли;
	пользовательИБ.РазделениеДанных = Новый Структура ( "Контрагент", Контрагент.Код );
	пользовательИБ.СохраняемоеЗначениеПароля = Справочники.Пользователи.ПолучитьХешПароля ( Пароль );
	пользовательИБ.ПоказыватьВСпискеВыбора = Ложь;
	пользовательИБ.Имя = Наименование;
	пользовательИБ.ПолноеИмя = НаименованиеПолное;
	пользовательИБ.Роли.Очистить ();
	Для Каждого строкаТЧ Из Роли Цикл
		Если ( строкаТЧ.Использование ) Тогда
			пользовательИБ.Роли.Добавить ( Метаданные.Роли [ строкаТЧ.Роль ] );
		КонецЕсли;
	КонецЦикла;
	пользовательИБ.Записать ();
	ИдентификаторПользователяИБ = пользовательИБ.УникальныйИдентификатор;
			
КонецПроцедуры

Процедура ПриЗаписи ( Отказ )
	
	Если ( ОбменДанными.Загрузка ) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании ( ОбъектКопирования )
	
	Контрагент = Справочники.Контрагенты.ПустаяСсылка ();
	ИдентификаторПользователяИБ = Неопределено;	

КонецПроцедуры
