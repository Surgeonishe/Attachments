
&НаСервере
Процедура ПриСозданииНаСервере ( Отказ, СтандартнаяОбработка )
	
	Если ( НЕ ЗначениеЗаполнено ( Параметры.Объект ) ) Тогда
		Возврат;
	КонецЕсли;
	ЭтаФорма.Заголовок = "Файлы " + Лев(Строка(Параметры.Объект.Ссылка), 25) + "...";
	ОбъектВладелец = Параметры.Объект;
	Папка = ОбъектВладелец.УникальныйИдентификатор ();
	прочитатьРегистр ();
	ХранениеФайлов = Константы.ХранениеФайлов.Получить () + "\" + Папка + "\";
	Масштаб = 100;
	ШаблонImage = "<HTML><img src=""file:\\" + ХранениеФайлов + "#path#"" width=""#width#%"" ></img></BODY></HTML>";
	// ШаблонPDF = "<HTML><iframe height=""#height#%"" src=""file:\\" + ХранениеФайлов + "#path#"" width=""#width#%""></iframe></BODY></HTML>";
	ШаблонPDF = "<html><style>h3 a{color: #3366FF;}</style><body> <h3 align=""center"">ПРОСМОТР ВРЕМЕННО НЕДОСТУПЕН!</h1><h3 align=""center""><a href=""link.html"">ДЛЯ ПРОСМОТРА ФАЙЛА В ОТДЕЛЬНОМ ОКНЕ НАЖМИТЕ НА ССЫЛКУ.</h1></body></html>";
	ШаблонТекст = "<html><body> <pre style=""word-wrap: break-word; white-space: pre-wrap;"">#text#</pre></body></html>";
	ЗаписыватьНабор = ЛОЖЬ;	
	
КонецПроцедуры

&НаСервере
Процедура прочитатьРегистр ()
	
	набор = РегистрыСведений.Файлы.СоздатьНаборЗаписей ();
	набор.Отбор.Объект.Значение = Параметры.Объект;
	набор.Отбор.Объект.Использование = ИСТИНА;
	набор.Отбор.Объект.ВидСравнения = ВидСравнения.Равно;
	набор.Прочитать ();
	ЗначениеВДанныеФормы ( набор, НаборЗаписей );
	заполнитьПредставление ();
	
КонецПроцедуры

&НаСервере
Процедура заполнитьПредставление ()
	
	Для Каждого данные Из НаборЗаписей Цикл
		данные.ФайлПредставление = данные.ИмяФайла + данные.Расширение;		
	КонецЦикла; 
	
КонецПроцедуры 

&НаКлиенте
Процедура НаборЗаписейПриАктивизацииСтроки ( Элемент )
	
	текущиеДанные = Элементы.НаборЗаписей.ТекущиеДанные;
	Если ( текущиеДанные <> Неопределено И ПоказыватьИзображение ) Тогда
		ИмяФайла = текущиеДанные.ИмяФайла + текущиеДанные.Расширение;
		сформироватьHTML ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура сформироватьHTML ()
	
	Если ( ИмяФайла = "" ) Тогда
		HTMLСтрока = "";
	Иначе
		расширение = Прав ( ИмяФайла, 4 );
		стр = "";
		Если ( НРег ( расширение ) = ".pdf" ) Тогда
			шаблон = ШаблонPDF;
			стр = СтрЗаменить ( шаблон, "#path#", ИмяФайла );
		ИначеЕсли ( НРег ( расширение ) = ".xml" ИЛИ НРег ( расширение ) = ".txt" ) Тогда
			шаблон = ШаблонТекст;
			текст = получитьТекстИзФайла ( ХранениеФайлов + ИмяФайла );
			стр = СтрЗаменить ( шаблон, "#text#", текст );
		ИначеЕсли ( НРег ( расширение ) = ".jpg" )
				ИЛИ ( НРег ( расширение ) = "jpeg" )
				ИЛИ ( НРег ( расширение ) = ".gif" )
				ИЛИ ( НРег ( расширение ) = ".png" )
				ИЛИ ( НРег ( расширение ) = ".tif" ) Тогда
			шаблон = ШаблонImage;
			стр = СтрЗаменить ( шаблон, "#path#", ИмяФайла );
		КонецЕсли; 
		стр = СтрЗаменить ( стр, "#width#", "" + Масштаб );
		высота = Масштаб * 2.05;
		стр = СтрЗаменить ( стр, "#height#", Формат ( высота, "ЧРД=." ) );
		HTMLСтрока = стр;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция получитьТекстИзФайла ( ИмяФайла )
	
	текст = Новый ТекстовыйДокумент ();
	текст.Прочитать ( ИмяФайла );
	с = текст.ПолучитьТекст ();
	текст = Неопределено; 	
	Возврат с;

КонецФункции 

&НаКлиенте
Процедура ДобавитьФайл ( Команда )
	
	ЗаписыватьНабор = ИСТИНА;
	п = Новый Структура ();
	РаботаСФайлами.Подготовить ( Новый ОписаниеОповещения ( "загрузитьФайл", ЭтотОбъект, п ) );
	
КонецПроцедуры

&НаКлиенте
Процедура загрузитьФайл ( Результат, Парам ) Экспорт 
	
	д = Новый ДиалогВыбораФайла ( РежимДиалогаВыбораФайла.Открытие );
	д.МножественныйВыбор = ЛОЖЬ;
	д.Заголовок = НСтр ( "ru = 'Выберите файл'" );
	д.ПредварительныйПросмотр = ИСТИНА;
	//д.Каталог = "\\server\ferko";
	д.Фильтр = НСтр ( "ru = 'Файлы (*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.pdf;*.xml;*.txt)|*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.pdf;*.xml;*.txt'" );
	д.Показать ( Новый ОписаниеОповещения ( "ОткрытьФайл", ЭтотОбъект, Парам ) );
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл ( Файлы, Парам ) Экспорт 	
	                                                                 
	Если ( Файлы = Неопределено ) Тогда
		Возврат;
	КонецЕсли;
	поместитьВХранилище ( Файлы [ 0 ] ); 
	
КонецПроцедуры

&НаКлиенте
Процедура поместитьВХранилище ( ИмяФайла )
	
	Если ( ПустаяСтрока ( ИмяФайла ) ) Тогда
		Возврат;
	КонецЕсли;
	файл = Новый Файл ( ИмяФайла ) ;
	Если ( НЕ файл.Существует () ) Тогда
		Возврат;		
	КонецЕсли;
	передаваемыеФайлы = Новый Массив;
	передаваемыеФайлы.Добавить ( Новый ОписаниеПередаваемогоФайла ( файл.ПолноеИмя ) );
	п = Новый Структура ();
	п.Вставить ( "ПолноеИмя", файл.ПолноеИмя );
	п.Вставить ( "Расширение", файл.Расширение );
	п.Вставить ( "Имя", файл.Имя );
	НачатьПомещениеФайлов ( Новый ОписаниеОповещения ( "ПомещениеФайлов", ЭтотОбъект, п ), передаваемыеФайлы, , ЛОЖЬ, УникальныйИдентификатор );  
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеФайлов ( Файлы, Параметры ) Экспорт
	
	Если ( Файлы.Количество () = 0 ) Тогда
		Возврат;
	КонецЕсли;
	сохранитьФайлы ( Файлы, Параметры );
	Элементы.НаборЗаписей.ТекущаяСтрока = НаборЗаписей [ ( НаборЗаписей.Количество () - 1  ) ].ПолучитьИдентификатор ();
	НаборЗаписейПриАктивизацииСтроки ( Элементы.НаборЗаписей );	
	
КонецПроцедуры

&НаСервере
Процедура сохранитьФайлы ( Файлы, Параметры )
	
	данные = ПолучитьИзВременногоХранилища ( получитьАдресФайла ( Файлы, Параметры.ПолноеИмя ) );
	создатьПапкуОбъекта ();
	ИмяФайла = Параметры.Имя;
 	данные.Записать ( ХранениеФайлов + ИмяФайла );
	добавитьЗапись ( ХранениеФайлов + ИмяФайла );
	адрес = файлы [ 0 ].Хранение;
	Если ( ЭтоАдресВременногоХранилища ( адрес ) ) Тогда
		УдалитьИзВременногоХранилища ( адрес ); 
	КонецЕсли;
	сформироватьHTML ();
	
КонецПроцедуры

&НаСервере
Процедура создатьПапкуОбъекта ()
	
	путьКаталога = Лев ( ХранениеФайлов, СтрДлина ( ХранениеФайлов ) - 1 );
	каталог = Новый Файл ( путьКаталога );
	Если ( каталог.Существует () ) Тогда
		// код ...  
	Иначе
		СоздатьКаталог ( каталог.ПолноеИмя );
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Функция получитьАдресФайла ( Файлы, ПолноеИмя )
	
	Для Каждого описание Из Файлы Цикл
		Если ( НРег ( описание.ПолноеИмя ) = НРег ( ПолноеИмя ) ) Тогда
			Возврат описание.Хранение;
		КонецЕсли;
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура СохранитьФайл ( Команда )
	
	текущиеДанные = Элементы.НаборЗаписей.ТекущиеДанные;
	Если ( текущиеДанные = Неопределено ) Тогда
		Возврат;
	КонецЕсли;
	п = Новый Структура ();
	п.Вставить ( "ПолноеИмяФайла", ИмяФайла );
	п.Вставить ( "ИмяФайла", текущиеДанные.ИмяФайла + текущиеДанные.Расширение );
	РаботаСФайлами.Подготовить ( Новый ОписаниеОповещения ( "сохранитьФайлНаДиск", ЭтотОбъект, п ) );
	
КонецПроцедуры

&НаКлиенте
Процедура сохранитьФайлНаДиск ( Результат, Парам ) Экспорт 
	
	режим = РежимДиалогаВыбораФайла.Сохранение;
	д = Новый ДиалогВыбораФайла ( режим );
	д.МножественныйВыбор = ЛОЖЬ;
	д.Заголовок = НСтр ( "ru = 'Выберите файл'" );
	д.Фильтр = НСтр ( "ru = 'Файлы (*.gif;*.jpg;*.jpeg;*.png;*.tif;*.pdf;*.txt)|*.gif;*.jpg;*.jpeg;*.png;*.tif;*.pdf;;*.txt'" );
	д.Показать ( Новый ОписаниеОповещения ( "ВыгрузитьФайл", ЭтотОбъект, Парам ) );
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьФайл ( Файлы, Парам ) Экспорт 	
	                                                                 
	Если ( Файлы = Неопределено ) Тогда
		Возврат;
	КонецЕсли;
	адрес = получитьФайл ();
	Если ( ЭтоАдресВременногоХранилища ( адрес ) ) Тогда
		данные = ПолучитьИзВременногоХранилища ( адрес );
	 	данные.Записать ( Файлы [ 0 ] );
	КонецЕсли; 
		
КонецПроцедуры
 
&НаСервере
Функция получитьФайл ()
	
	Если ( ИмяФайла = "" ) Тогда
		Возврат "";
	КонецЕсли;
	данные = Новый ДвоичныеДанные ( ХранениеФайлов + "\" + ИмяФайла );
	Возврат ПоместитьВоВременноеХранилище ( данные );
	
КонецФункции

&НаКлиенте
Процедура УдалитьФайл ( Команда )
	
	ЗаписыватьНабор = ИСТИНА;
	п = Новый Структура ();
	п.Вставить ( "Индекс", НаборЗаписей.Индекс ( Элементы.НаборЗаписей.ТекущиеДанные ) );
	с = "Удалить файл - " + ИмяФайла + "
	|без возможности восстановления?
	|";
	ПоказатьВопрос ( Новый ОписаниеОповещения ( "УдалитьЗапись", ЭтотОбъект, п ), с, РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Нет );
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись ( Результат, Парам ) Экспорт 	
	
	Если ( Результат <> КодВозвратаДиалога.Да ) Тогда
		Возврат;
	КонецЕсли;
	Если ( Парам.Индекс <> Неопределено ) Тогда
		данные = НаборЗаписей.Получить ( Парам.Индекс );
		путьКФайлу = ХранениеФайлов + данные.ИмяФайла + данные.Расширение; 
		ИмяФайла = "";
		сформироватьHTML ();
		удалитьПрикрепленныйФайл ( путьКФайлу ); 
		НаборЗаписей.Удалить ( Парам.Индекс );
		приИзмененииНабораЗаписей ();
		ИмяФайла = "";
		сформироватьHTML ();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура удалитьПрикрепленныйФайл ( Путь )
	
	УдалитьФайлы ( Путь );
	
КонецПроцедуры 

&НаКлиенте
Процедура ПередЗакрытием ( Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка )
	
	// код ...
	
КонецПроцедуры

&НаСервере
Процедура приИзмененииНабораЗаписей ()
	
	Если ( ЗаписыватьНабор И ЗначениеЗаполнено ( ОбъектВладелец ) ) Тогда
		набор = ДанныеФормыВЗначение ( НаборЗаписей, Тип ( "РегистрСведенийНаборЗаписей.Файлы" ) );
		набор.Записать ();	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьФайл ( Команда )
	
	ПоказыватьИзображение = НЕ ПоказыватьИзображение;
	обновитьВидимость ();
	
КонецПроцедуры

&НаКлиенте
Процедура обновитьВидимость ( Элемент = Неопределено )
	
	Если ( Элемент = Неопределено ИЛИ Элемент.Имя = "ПоказыватьФайл" ) Тогда
		Элементы.ГруппаHTML.Видимость = ПоказыватьИзображение;
		Элементы.ПоказыватьИзображение.Пометка = ПоказыватьИзображение;
	КонецЕсли; 
	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии ( Отказ )
	
	ПоказыватьИзображение = ИСТИНА;
	обновитьВидимость ();
	Элементы.Масштаб.Заголовок = "Масштаб - " + Масштаб + " %";
	
КонецПроцедуры

&НаСервере
Процедура добавитьЗапись ( ИмяФайла )
	
	файл = Новый Файл ( ИмяФайла );
	запись = НаборЗаписей.Добавить ();
	запись.Объект = ОбъектВладелец;
	запись.ИмяФайла = файл.ИмяБезРасширения;
	запись.Расширение = файл.Расширение;
	запись.Дата = ТекущаяДата ();
	запись.Размер = ( файл.Размер () / 1024 );
	запись.Автор = ПараметрыСеанса.ТекущийПользователь;
	запись.Папка = Папка;
	запись.ФайлПредставление = файл.Имя;
	приИзмененииНабораЗаписей ();
	
КонецПроцедуры

&НаКлиенте
Процедура МасштабПриИзменении ( Элемент )
	
	Элементы.Масштаб.Заголовок = "Масштаб " + Масштаб + " %";
	сформироватьHTML ();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьМасштаб ( Команда )
	
	коэффициент = 0;
	Если ( Команда.Имя = "УвеличитьМасштаб" ) Тогда
		коэффициент = 1;
	ИначеЕсли ( Команда.Имя = "УменьшитьМасштаб" ) Тогда
		коэффициент = - 1;
	КонецЕсли;
	Масштаб = Масштаб + коэффициент * 25;
	сформироватьHTML ();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаМасштаб ( Команда )
	
	// код ...	
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПеретаскивание ( Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле )
	
	СтандартнаяОбработка = ЛОЖЬ;
	файл = ПараметрыПеретаскивания.Значение;
	Если ( ТипЗнч ( файл ) = Тип ( "Файл" ) ) Тогда
		поместитьВХранилище ( файл.ПолноеИмя );
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПроверкаПеретаскивания ( Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле )
	
	СтандартнаяОбработка = ЛОЖЬ;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьФайлы ( Команда )
	
	ПоказатьВопрос ( Новый ОписаниеОповещения ( "ВосстановитьФайлыВопрос", ЭтотОбъект, Новый Структура () ), "Восстановить файлы?", РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Нет );
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьФайлыВопрос ( Результат, Парам )	Экспорт
	
	Если ( Результат = КодВозвратаДиалога.Нет ) Тогда
		Возврат;
	КонецЕсли;
	восстановитьФайлыИзКаталога ();
	
КонецПроцедуры

&НаСервере
Процедура восстановитьФайлыИзКаталога ()
	
	путьКаталога = Лев ( ХранениеФайлов, СтрДлина ( ХранениеФайлов ) - 1 );
	каталог = Новый Файл ( путьКаталога );
	Если ( каталог.Существует () ) Тогда
		мФайлов = НайтиФайлы ( путьКаталога, "*.*", ИСТИНА );
		колвоФайлов = 0;
		Если ( мФайлов.Количество () > 0 ) Тогда
			ЗаписыватьНабор = ИСТИНА;
			Для Каждого найденныйФайл Из мФайлов Цикл
				_отбор = Новый Структура ( "ИмяФайла, Расширение", найденныйФайл.ИмяБезРасширения, найденныйФайл.Расширение ); 
				записи = НаборЗаписей.НайтиСтроки ( _отбор ); 
				Если ( записи.Количество () = 0 ) Тогда
					запись = НаборЗаписей.Добавить ();
					запись.Объект = ОбъектВладелец;
					запись.ИмяФайла = найденныйФайл.ИмяБезРасширения;
					запись.Расширение = найденныйФайл.Расширение;
					запись.Дата = ТекущаяДата ();
					запись.Размер = ( найденныйФайл.Размер () / 1024 );
					запись.Автор = ПараметрыСеанса.ТекущийПользователь;
					запись.Папка = Папка;
					запись.ФайлПредставление = найденныйФайл.Имя;
					колвоФайлов = колвоФайлов + 1;	
				КонецЕсли; 
			КонецЦикла; 			
		КонецЕсли; 
	КонецЕсли;
	приИзмененииНабораЗаписей ();
	Сообщить ( "Восстановлено " + Формат ( колвоФайлов, "ЧН=0" ) + " файлов!", СтатусСообщения.Обычное );   
	
КонецПроцедуры 

&НаКлиенте
Процедура HTMLСтрокаПриНажатии ( Элемент, ДанныеСобытия, СтандартнаяОбработка )
	
	Если ( ДанныеСобытия.Href = Неопределено ) Тогда
		Возврат;
	КонецЕсли; 
	СтандартнаяОбработка = Ложь;
	текущиеДанные = Элементы.НаборЗаписей.ТекущиеДанные;
	имяФайла = ХранениеФайлов + текущиеДанные.ИмяФайла + текущиеДанные.Расширение;
	ЗапуститьПриложение ( ИмяФайла );
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьHTML ( Команда )
	
	Элементы.HTMLСтрока.Документ.execCommand ( "Print" ); 
	
КонецПроцедуры