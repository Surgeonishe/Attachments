
Процедура ВыбратьФайлы ( ОповещениеВозврата ) Экспорт
	
	п = Новый Структура ();
	п.Вставить ( "ОповещениеВозврата", ОповещениеВозврата );
	диалог = ПолучитьДиалогВыбораФайлов ();
    завершение = Новый ОписаниеОповещения ( "ЗавершениеЗагрузки", ЭтотОбъект, п );
    прогресс = Новый ОписаниеОповещения ( "ХодЗагрузки", ЭтотОбъект );
	передНачалом = Новый ОписаниеОповещения ( "ПередНачаломЗагрузки", ЭтотОбъект );
    НачатьПомещениеФайловНаСервер ( завершение, прогресс, передНачалом, диалог, Новый УникальныйИдентификатор () );
	
КонецПроцедуры

Функция ПолучитьДиалогВыбораФайлов () Экспорт
	
	диалог = Новый ПараметрыДиалогаПомещенияФайлов ();
	диалог.МножественныйВыбор = Истина;
	диалог.Заголовок = НСтр ( "ru = 'Выберите файл (ы)';en = 'Select file (s)'" );
   	диалог.Фильтр = ПолучитьФильтрФайлов ();
	Возврат диалог;

КонецФункции

Функция ПолучитьФильтрФайлов () Экспорт
	
	фильтр = НСтр ( "ru = 'PDF '; en = 'PDF '; ua = 'PDF '" ) + "(*.pdf)|*.pdf|"
		+ НСтр ( "ru = 'Word '; en = 'Word '; ua = 'Word '" ) + "(*.doc;*.docx)|*.doc;*docx|"
		+ НСтр ( "ru = 'Excel '; en = 'Excel '; ua = 'Excel '" ) + "(*.xls;*.xlsx)|*.xls;*xlsx|"
		+ НСтр ( "ru = 'Текст '; en = 'Text '; ua = 'Текст '" ) + "(*.txt)|*.txt|"
		+ НСтр ( "ru = 'XML '; en = 'XML '; ua = 'XML '" ) + "(*.xml)|*.xml|"
		+ НСтр ( "ru = 'Изображения '; en = 'Images '; ua = 'Зображення '" ) + "(*.bmp;*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.tif)|*.bmp;*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.tif|"
		+ НСтр ( "ru = 'Все файлы '; en = 'All types '; ua = 'Усі файли '" ) + "(*.bmp;*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.tif;*.pdf;*.xml;*.txt;*.doc;*.docx;*.xls;*.xlsx)|*.bmp;*.gif;*.jpg;*.jpeg;*.png;*.tiff;*.tif;*.pdf;*.xml;*.txt;*.doc;*.docx;*.xls;*.xlsx|";
	Возврат фильтр;

КонецФункции

Процедура ЗавершениеЗагрузки ( ОписаниеФайлов, Параметры ) Экспорт

	Если ОписаниеФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	файлы = Новый Массив ();
	Для Каждого описание Из ОписаниеФайлов Цикл
		п = Новый Структура ();
		п.Вставить ( "Адрес", описание.Адрес );
		п.Вставить ( "Имя", описание.СсылкаНаФайл.Имя);
		п.Вставить ( "Расширение", описание.СсылкаНаФайл.Расширение );
		п.Вставить ( "Размер", описание.СсылкаНаФайл.Размер () );
		файлы.Добавить ( п );
	КонецЦикла;
	данные = Новый Структура ();
	данные.Вставить ( "Файлы", файлы );
	ВыполнитьОбработкуОповещения ( Параметры.ОповещениеВозврата, данные );
				
КонецПроцедуры

Процедура ХодЗагрузки ( ПомещаемыйФайл, Процент, Отказ, ПроцентВсего, ОтказВсего, Параметры ) Экспорт

	Если ( ОтказВсего ) Тогда
		// код ...	
	Иначе
		с = СтрШаблон ( НСтр ( "ru = 'Загрузка файла %1'" ), ПомещаемыйФайл.Имя );
		пояснение = СтрШаблон ( Нстр ( "ru = 'Размер файла %1 байт'" ), ПомещаемыйФайл.Размер () );
		Состояние ( с, ПроцентВсего, пояснение,  );
	КонецЕсли;

КонецПроцедуры

Процедура ПередНачаломЗагрузки ( ПомещаемыеФайлы, Отказ, Параметры ) Экспорт
	
	максимум = 10 * 1024 * 1024; // пока лимит в 10 МБайт
	Для Каждого помещаемыйФайл Из ПомещаемыеФайлы Цикл
		размер = помещаемыйФайл.Размер ();
		Если ( размер > максимум ) Тогда
			Отказ = Истина;
			с = СтрШаблон ( НСтр ( "ru = 'Отказ. Загружаемый файл «%1» имеет размер более 10 мегабайта'"), помещаемыйФайл.Имя );
			сп = Новый СообщениеПользователю ();
			сп.Текст = с;
			сп.Сообщить ();
		КонецЕсли;
	КонецЦикла;	
			
КонецПроцедуры

Функция ПолучитьРасширениеФайла ( ИмяФайла ) Экспорт
	
	поз = 0;
	расширение = ИмяФайла;
	Пока Истина Цикл
		поз = Найти ( расширение, "." );
		Если ( НЕ поз ) Тогда
			Прервать;			
		Иначе
			расширение = Сред ( расширение, поз + 1 );
		КонецЕсли;	
		
	КонецЦикла;
	Возврат ? ( расширение = ИмяФайла, "", НРег ( расширение ) );

КонецФункции

Функция ИндексПиктограммы ( ИмяФайла ) Экспорт
	
	расширение = ПолучитьРасширениеФайла ( ИмяФайла );
	индекс = -1;
	Если ( Расширение = "gif" ) Тогда
		индекс = 48;
	ИначеЕсли ( Расширение = "jpg" ) Тогда
		индекс = 42;
	ИначеЕсли ( Расширение = "jpeg" ) Тогда
		индекс = 42;
	ИначеЕсли ( Расширение = "png" ) Тогда
		индекс = 50;
	ИначеЕсли ( Расширение = "tiff" ) Тогда
		индекс = 46;
	ИначеЕсли ( Расширение = "tif" ) Тогда
		индекс = 46;
	ИначеЕсли ( Расширение = "bmp" ) Тогда
		индекс = 44;
	ИначеЕсли ( Расширение = "pdf" ) Тогда
		индекс = 52;
	ИначеЕсли ( Расширение = "xml" ) Тогда
		индекс = 30;
	ИначеЕсли ( Расширение = "txt" ) Тогда
		индекс = 10;
	ИначеЕсли ( Расширение = "doc" ) Тогда
		индекс = 18;
	ИначеЕсли ( Расширение = "docx" ) Тогда
		индекс = 18;
	ИначеЕсли ( Расширение = "xls" ) Тогда
		индекс = 20;
	ИначеЕсли ( Расширение = "xlsx" ) Тогда
		индекс = 20;
	КонецЕсли;
	Возврат индекс;

КонецФункции

Процедура ВыгрузитьФайл ( Адрес, ИмяФайла ) Экспорт
	
	диалог = ПолучитьДиалогПолученияФайлов ();
	НачатьПолучениеФайлаССервера ( Адрес, "", диалог );
			
КонецПроцедуры

Функция ПолучитьДиалогПолученияФайлов () Экспорт
	
	диалог = Новый ПараметрыДиалогаПолученияФайлов ();
	диалог.Заголовок = НСтр ( "ru = 'Выберите файл';en = 'Select file'" );
	диалог.ВыборКаталога = Ложь;
	Возврат диалог;

КонецФункции