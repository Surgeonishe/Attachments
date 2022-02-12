
Процедура ЗаписатьФайл ( Параметры ) Экспорт
	
	набор = РегистрыСведений.Файлы.СоздатьНаборЗаписей ();
	набор.Отбор.Объект.Установить ( Параметры.Объект );
	набор.Отбор.КлючСтроки.Установить ( Параметры.КлючСтроки );
	набор.Прочитать ();
	набор.Очистить ();
	запись = набор.Добавить ();
	ЗаполнитьЗначенияСвойств ( запись, Параметры );
	п = получитьПредставления ( Параметры );
	запись.Папка = п.Папка;
	набор.Записать ();
	записатьФайлНаДиск  ( Параметры.Адрес, запись, п.Ключ );
	
КонецПроцедуры

Функция получитьПредставления ( Параметры )
	
	имя = Параметры.Объект.Метаданные ().Имя;
	с = "
	|выбрать
	|	Док.Номер как Объект,
	|	Ключи.Код как КлючСтроки
	|из
	|	Документ." + имя + " как Док,
	|	Справочник.КлючиСтрок как Ключи
	|где
	|	Док.Ссылка = &Объект
	|	и Ключи.Ссылка = &КлючСтроки
	|";
	запрос = Новый Запрос ( с );
	запрос.УстановитьПараметр ( "Объект", Параметры.Объект );
	запрос.УстановитьПараметр ( "КлючСтроки", Параметры.КлючСтроки );
	результат = запрос.Выполнить ();
	выборка = результат.Выбрать ();
	выборка.Следующий ();
	п = Новый Структура ();
	п.Вставить ( "Папка", ( имя + выборка.Объект ) );
	п.Вставить ( "Ключ", выборка.КлючСтроки );
	Возврат п;

КонецФункции

Процедура записатьФайлНаДиск ( Адрес, Запись, Ключ )
	
	данные = ПолучитьИзВременногоХранилища ( Адрес );
	путь = Константы.ХранениеФайлов.Получить () + Запись.Папка;
	СоздатьКаталог ( путь );
 	данные.Записать ( путь + "\" + ПолучитьПрефиксКлюча ( Ключ ) + запись.ИмяФайла );
	Если ( ЭтоАдресВременногоХранилища ( Адрес ) ) Тогда
		УдалитьИзВременногоХранилища ( Адрес ); 
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПрефиксКлюча ( Ключ ) Экспорт
	
	Возврат ( "КЛЮЧ_" + Формат ( Ключ, "ЧГ=0;" ) + " " );

КонецФункции

Процедура УдалитьЗапись ( Параметры ) Экспорт
	
	набор = РегистрыСведений.Файлы.СоздатьНаборЗаписей ();
	набор.Отбор.Объект.Установить ( Параметры.Объект );
	набор.Отбор.КлючСтроки.Установить ( Параметры.КлючСтроки );
	набор.Прочитать ();
	Если ( набор.Количество () > 0 ) Тогда
		папка = набор [ 0 ].Папка;
		полноеИмя = ПолучитьПолноеИмя ( набор [ 0 ] );
		УдалитьФайлы ( полноеИмя );
		удалитьПапку ( папка );
	КонецЕсли;
	набор.Очистить ();
	набор.Записать ();
			
КонецПроцедуры

Функция ПолучитьПолноеИмя ( Запись )
	
	путь = Константы.ХранениеФайлов.Получить () + Запись.Папка;
	полноеИмя = путь + "\" + ПолучитьПрефиксКлюча ( Запись.КлючСтроки ) + Запись.ИмяФайла;
	Возврат полноеИмя;
			
КонецФункции

Процедура удалитьПапку ( Папка )
	
	// код ...
	
КонецПроцедуры

Функция ПолучитьДетали ( Параметры ) Экспорт
	
	с = "
	|выбрать
	|	Объект как Объект,
	|	КлючСтроки как КлючСтроки,
	|	Дата как Дата,
	|	Размер как Размер,
	|	Автор как Автор,
	|	Папка как Папка,
	|	ИмяФайла как ИмяФайла,
	|	Расширение как Расширение
	|из
	|	РегистрСведений.Файлы
	|где
	|	Объект = &Объект
	|	и КлючСтроки = &КлючСтроки
	|";
	запрос = Новый Запрос ( с );
	запрос.УстановитьПараметр ( "Объект", Параметры.Объект );
	запрос.УстановитьПараметр ( "КлючСтроки", Параметры.КлючСтроки );
	результат = запрос.Выполнить ();
	выборка = результат.Выбрать ();
	п = Неопределено;
	Если ( выборка.Следующий () ) Тогда
		п = Новый Структура;
		п.Вставить ( "Объект", выборка.Объект);
		п.Вставить ( "КлючСтроки", выборка.КлючСтроки);
		п.Вставить ( "Дата", выборка.Дата);
		п.Вставить ( "Размер", выборка.Размер);
		п.Вставить ( "Автор", выборка.Автор);
		п.Вставить ( "Папка", выборка.Папка);
		п.Вставить ( "ИмяФайла", выборка.ИмяФайла);
		п.Вставить ( "Расширение", выборка.Расширение);
		полноеИмя = ПолучитьПолноеИмя ( п );
		п.Вставить ( "ПолноеИмя", полноеИмя );
	КонецЕсли;
	Возврат п;

КонецФункции