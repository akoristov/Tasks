﻿
&НаКлиенте
Процедура КомандаРасширеннаяНастройкаПоВерсиям(Команда)
	ВключенаРасширеннаяНастройкаПоВерсиям = НЕ ВключенаРасширеннаяНастройкаПоВерсиям;
	УстановитьВидимостьДоступность();
	УстановитьОтборыВСвязанныхТЧ();
КонецПроцедуры                      

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ГруппаРасширеннаяНастройкаПоВерсиям.Видимость = Ложь;
	Если ВключенаРасширеннаяНастройкаПоВерсиям Тогда
		Элементы.ГруппаРасширеннаяНастройкаПоВерсиям.Видимость = Истина;
	Конецесли;
КонецПроцедуры 


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьТЧИзмененныеОбъектыНаСервере();
	УстановитьВидимостьДоступность();
	ВыполнитьЛокализацию();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(59);//Описание релиза
	МассивКодовСообщений.Добавить(60);//Состав релиза
	МассивКодовСообщений.Добавить(61);//Номер релиза
	МассивКодовСообщений.Добавить(62);//Описание релиза	
	МассивКодовСообщений.Добавить(63);//Подбор
	МассивКодовСообщений.Добавить(64);//Изменить статус
	МассивКодовСообщений.Добавить(65);//Расширенная настройка по версиям
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
КонецПроцедуры //ВыполнитьЛокализацию()


&НаКлиенте
Процедура КомандаПодборЗадач(Команда)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьПодборЗадачи", ЭтаФорма, );
	
	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаВыбораМножественный",ПараметрыФормы,,,,,ОповещениеОЗакрытии);	

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПодборЗадачи(РезультатЗакрытия, ДопПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	Конецесли;
	МассивВыбранныхЗадач = РезультатЗакрытия;
	Для каждого ЭлМассиваВыбранныхЗадач из МассивВыбранныхЗадач цикл
		пЗадача = ЭлМассиваВыбранныхЗадач;
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить("Задача",пЗадача);
		НайденныеСтроки = Объект.ТЧЗадачи.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Продолжить;
		Конецесли;
		СтрокаЗадачи = Объект.ТЧЗадачи.Добавить();	
		СтрокаЗадачи.Задача = пЗадача;
	Конеццикла;
	
	ЗаполнитьИсториюХранилищаПоЗадачам();
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьИсториюХранилищаПоЗадачам(СтрокаЗадачиСтруктура = Неопределено)
	Если СтрокаЗадачиСтруктура = Неопределено Тогда
		Объект.ИсторияХранилища.Очистить();
	Иначе
		пЗадача = СтрокаЗадачиСтруктура.Задача;
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("Задача",пЗадача);
		СтрокиКУдалению = Объект.ИсторияХранилища.НайтиСтроки(ПараметрыОтбора);
		Для каждого СтрокаКУдалению из СтрокиКУдалению цикл
			Объект.ИсторияХранилища.Удалить(СтрокаКУдалению);		
		Конеццикла;		
	Конецесли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Конфигурация) Тогда
		Сообщить("Ошибка! не указана конфигурация по которой необходимо заполнить изменения по задачам");
		Возврат;
	Конецесли;
	
	Если СтрокаЗадачиСтруктура = Неопределено Тогда
		МассивЗадач = Объект.ТЧЗадачи.Выгрузить(,"Задача");
	Иначе
		МассивЗадач = Новый Массив();
		МассивЗадач.Добавить(СтрокаЗадачиСтруктура.Задача);
	Конецесли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	узИсторияКонфигураций.Ссылка,
	|	узИсторияКонфигураций.Задача
	|ИЗ
	|	Справочник.узИсторияКонфигураций КАК узИсторияКонфигураций
	|ГДЕ
	|	узИсторияКонфигураций.Задача В(&МассивЗадач)
	|	И узИсторияКонфигураций.Владелец = &Конфигурация
	|
	|УПОРЯДОЧИТЬ ПО
	|	узИсторияКонфигураций.ДатаВерсии";
	
	Запрос.УстановитьПараметр("МассивЗадач", МассивЗадач);
	Запрос.УстановитьПараметр("Конфигурация", Объект.Конфигурация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаИсторияХранилища = Объект.ИсторияХранилища.Добавить();
		СтрокаИсторияХранилища.Пометка = Истина;
		СтрокаИсторияХранилища.ЗаписьИсторииХранилища = Выборка.Ссылка;
		СтрокаИсторияХранилища.Задача = Выборка.Задача;
	КонецЦикла;

	ЗаполнитьИзмененныеОбъекты(СтрокаЗадачиСтруктура);
	
	ОчиститьСвязанныеТЧНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОчиститьСвязанныеТЧНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	пОбъект.ОчиститьСвязанныеТЧ();
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьИзмененныеОбъекты(СтрокаЗадачиСтруктура = Неопределено)
	Если СтрокаЗадачиСтруктура = Неопределено Тогда
		Объект.ИзмененныеОбъекты.Очистить();
	Иначе
		пЗадача = СтрокаЗадачиСтруктура.Задача;
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("Задача",пЗадача);
		СтрокиКУдалению = Объект.ИзмененныеОбъекты.НайтиСтроки(ПараметрыОтбора);
		Для каждого СтрокаКУдалению из СтрокиКУдалению цикл
			Объект.ИзмененныеОбъекты.Удалить(СтрокаКУдалению);		
		Конеццикла;		
	Конецесли;
	МассивЗаписейИсторииХранилища = Новый Массив();
	Для каждого СтрокаИсторияХранилища из Объект.ИсторияХранилища цикл
		Если СтрокаЗадачиСтруктура <> Неопределено
			И СтрокаЗадачиСтруктура.Задача <> СтрокаИсторияХранилища.Задача Тогда
			Продолжить;
		Конецесли;		
		Если НЕ СтрокаИсторияХранилища.Пометка Тогда 
			Продолжить;
		Конецесли;
		МассивЗаписейИсторииХранилища.Добавить(СтрокаИсторияХранилища.ЗаписьИсторииХранилища);
	Конеццикла;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	узИсторияКонфигурацийИзмененныеОбъекты.ИдентификаторОбъектаМетаданных,
	|	узИсторияКонфигурацийИзмененныеОбъекты.Ссылка.Задача КАК Задача
	|ИЗ
	|	Справочник.узИсторияКонфигураций.ИзмененныеОбъекты КАК узИсторияКонфигурацийИзмененныеОбъекты
	|ГДЕ
	|	узИсторияКонфигурацийИзмененныеОбъекты.Ссылка В(&МассивЗаписейИсторииХранилища)
	|
	|УПОРЯДОЧИТЬ ПО
	|	узИсторияКонфигурацийИзмененныеОбъекты.ИдентификаторОбъектаМетаданных.Наименование";
	
	Запрос.УстановитьПараметр("МассивЗаписейИсторииХранилища", МассивЗаписейИсторииХранилища);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаИзмененныеОбъекты = Объект.ИзмененныеОбъекты.Добавить();
		СтрокаИзмененныеОбъекты.Задача = Выборка.Задача;
		СтрокаИзмененныеОбъекты.ИдентификаторОбъектаМетаданных = Выборка.ИдентификаторОбъектаМетаданных;
	КонецЦикла;	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьОтборыВСвязанныхТЧ()
	Перем пЗадача;
	
	СтрокаЗадачи = Элементы.ТЧЗадачи.ТекущиеДанные;	
	Если СтрокаЗадачи <> Неопределено тогда
		пЗадача = СтрокаЗадачи.Задача;	
	Конецесли;	
	
	Если ВключенаРасширеннаяНастройкаПоВерсиям Тогда
		Элементы.ИсторияХранилища.ОтборСтрок = Новый ФиксированнаяСтруктура("Задача", пЗадача);
		Элементы.ИзмененныеОбъекты.ОтборСтрок = Новый ФиксированнаяСтруктура("Задача", пЗадача);	
	Конецесли;
КонецПроцедуры 


&НаКлиенте
Процедура ПриИзмененииЗадачи(СтрокаЗадачи)
	СтрокаЗадачиСтруктура = Новый Структура();
	СтрокаЗадачиСтруктура.Вставить("Задача",СтрокаЗадачи.Задача);
	ЗаполнитьИсториюХранилищаПоЗадачам(СтрокаЗадачиСтруктура);
КонецПроцедуры 

&НаКлиенте
Процедура ЗадачиПриАктивизацииСтроки(Элемент)
	УстановитьОтборыВСвязанныхТЧ();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиЗадачаПриИзменении(Элемент)
	СтрокаЗадачи = Элементы.ТЧЗадачи.ТекущиеДанные;	
	Если СтрокаЗадачи = Неопределено тогда
		Возврат;
	Конецесли;	
	
	ПриИзмененииЗадачи(СтрокаЗадачи);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияХранилищаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтрокаИсторияХранилища = Элементы.ИсторияХранилища.ТекущиеДанные;	
	Если СтрокаИсторияХранилища = Неопределено тогда
		Возврат;	
	Конецесли;	
	Если Поле.Имя = "ИсторияХранилищаПометка" Тогда
		Возврат;
	Конецесли;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ",СтрокаИсторияХранилища.ЗаписьИсторииХранилища);
	ОткрытьФорму("Справочник.узИсторияКонфигураций.Форма.ФормаЭлемента",ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияХранилищаПометкаПриИзменении(Элемент)
	СтрокаЗадачи = Элементы.ТЧЗадачи.ТекущиеДанные;	
	Если СтрокаЗадачи <> Неопределено тогда
		пЗадача = СтрокаЗадачи.Задача;	
	Конецесли;	
	
	СтрокаЗадачиСтруктура = Новый Структура();
	СтрокаЗадачиСтруктура.Вставить("Задача",СтрокаЗадачи.Задача);
	
	ЗаполнитьИзмененныеОбъекты(СтрокаЗадачиСтруктура);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ФорматированныйТекст = ТекущийОбъект.Содержание.Получить();	

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
	
	пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
	ТекущийОбъект.ТекстСодержания = пТекстСодержания;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСодержаниеТекстИзФорматированногоТекста() 
	ТекстHTML = "";
	Вложения = Новый Структура;
	ФорматированныйТекст.ПолучитьHTML(ТекстHTML, Вложения);
	
	пТекстСодержания = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ТекстHTML);
	Если НЕ ЗначениеЗаполнено(пТекстСодержания) Тогда
		пТекстСодержания = Объект.ТекстСодержания;
	Конецесли;
	Возврат пТекстСодержания;
КонецФункции 


&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ВыполнитьДействиеДляАктивнойСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеДляАктивнойСтраницы()
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ГруппаОписаниеРелиза Тогда
		ЗаполнитьТЧИзмененныеОбъектыНаСервере();
	Конецесли;
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьТЧИзмененныеОбъектыНаСервере()
	ТЧИзмененныеОбъекты.Очистить();
	ВТИзмененныеОбъекты = Объект.ИзмененныеОбъекты.Выгрузить();
	
	ВТИзмененныеОбъекты.Свернуть("ИдентификаторОбъектаМетаданных");
	ВТИзмененныеОбъекты.Колонки.Добавить("Порядок");
	
	Для каждого СтрокаВТИзмененныеОбъекты из ВТИзмененныеОбъекты цикл
		пПолноеИмяМетаданных = СтрокаВТИзмененныеОбъекты.ИдентификаторОбъектаМетаданных.ПолноеИмяМетаданных;
		
		пПорядок = ПолучитьПорядокДляПолноеИмяМетаданных(пПолноеИмяМетаданных);
		
		СтрокаВТИзмененныеОбъекты.Порядок = пПорядок + пПолноеИмяМетаданных;
	Конеццикла;
	
	ВТИзмененныеОбъекты.Сортировать("Порядок");
	
	НС = 1;
	Для каждого СтрокаВТИзмененныеОбъекты из ВТИзмененныеОбъекты цикл
		СтрокаТЧИзмененныеОбъекты = ТЧИзмененныеОбъекты.Добавить();
		СтрокаТЧИзмененныеОбъекты.НомерСтроки = НС;
		СтрокаТЧИзмененныеОбъекты.ИдентификаторОбъектаМетаданных = СтрокаВТИзмененныеОбъекты.ИдентификаторОбъектаМетаданных;
		НС = НС + 1;
	Конеццикла;
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьПорядокДляПолноеИмяМетаданных(пПолноеИмяМетаданных)
	
	пПорядок = "999_";
	
	НомерПорядка = 1;
	
	Если Найти(пПолноеИмяМетаданных,".") = 0 Тогда
		пПорядок = "001_";
	ИначеЕсли Найти(Лев(пПолноеИмяМетаданных,5),"Общие") > 0 Тогда
		пПорядок = "002_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Константа") > 0 Тогда
		пПорядок = "003_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Справочник") > 0 Тогда
		пПорядок = "004_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Документ") > 0 Тогда
		пПорядок = "005_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"ЖурналДокументов") > 0 Тогда
		пПорядок = "006_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Перечисление") > 0 Тогда
		пПорядок = "007_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Отчет") > 0 Тогда
		пПорядок = "008_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Обработка") > 0 Тогда
		пПорядок = "009_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"ПланВидовХарактеристик") > 0 Тогда
		пПорядок = "010_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"ПланСчетов") > 0 Тогда
		пПорядок = "011_";
	ИначеЕсли Найти(пПолноеИмяМетаданных,"ПланВидовРасчета") > 0 Тогда
		пПорядок = "012_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"РегистрСведений") > 0 Тогда
		пПорядок = "013_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"РегистрНакопления") > 0 Тогда
		пПорядок = "014_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"РегистрБухгалтерии") > 0 Тогда
		пПорядок = "015_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"РегистрРасчета") > 0 Тогда
		пПорядок = "016_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"БизнесПроцесс") > 0 Тогда
		пПорядок = "017_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"Задача") > 0 Тогда
		пПорядок = "018_";		
	ИначеЕсли Найти(пПолноеИмяМетаданных,"ВнешнийИсточникДанных") > 0 Тогда
		пПорядок = "019_";				
	Конецесли;
	
	Возврат пПорядок;
КонецФункции 

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	Если Объект.Ссылка.Пустая() Тогда
		Заголовок = "Выпуск релиза от "+Объект.Дата+" - Новый*";
	Иначе
		Заголовок =  ""+Объект.Ссылка+" "+?(Объект.Проведен,"Проведен",?(Объект.ПометкаУдаления,"Помечен на удаление","Записан"));
	Конецесли;	
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиПослеУдаления(Элемент)
	ОчиститьСвязанныеТЧНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДанныеПоЗадачам(Команда)
	ЗаполнитьИсториюХранилищаПоЗадачам();
КонецПроцедуры

&НаСервере
Процедура КомандаИзменитьСтатусНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура КомандаИзменитьСтатус(Команда)
	Перем НовыйСтатус;
	
	МассивЗадач = Новый Массив();
	Для каждого ИдентификаторСтроки Из Элементы.ТЧЗадачи.ВыделенныеСтроки Цикл
		СтрокаТЧЗадачи = Объект.ТЧЗадачи.НайтиПоИдентификатору(ИдентификаторСтроки);
		МассивЗадач.Добавить(СтрокаТЧЗадачи.Задача);
	КонецЦикла;	
	
	ПараметрыФормыВвода = Новый Структура();
	ПараметрыФормыВвода.Вставить("МассивЗадач",МассивЗадач);
	
	НовыйСтатус  = ПредопределенноеЗначение("Справочник.узСтатусыЗадачи.НаТестированииПоказПользователям");
	
	ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.узСтатусыЗадачи");
	Оповещение = Новый ОписаниеОповещения("ПослеВыбораНовогоСтатусаДляЗадач",ЭтаФорма, ПараметрыФормыВвода);
	
	ПоказатьВводЗначения(Оповещение, НовыйСтатус, "Укажите новый статус для выбранных задач", ОписаниеТипов);
	
КонецПроцедуры



&НаКлиенте
Процедура ПослеВыбораНовогоСтатусаДляЗадач(НовыйСтатус, ПараметрыФормыВвода) Экспорт
	Если НЕ ЗначениеЗаполнено(НовыйСтатус) Тогда
		Сообщить("Ошибка! не выбран новый статус для задач");
		Возврат;
	Конецесли;
	
	МассивЗадач = ПараметрыФормыВвода.МассивЗадач;
	
	ИзменитьСтатусДляВыбранныхЗадачНаСервере(НовыйСтатус, МассивЗадач);
	Для каждого пЗадача из МассивЗадач цикл
		Сообщить("Указан новый статус ["+НовыйСтатус+"] для задачи ["+пЗадача+"]");
		ОповеститьОбИзменении(пЗадача);		
	Конеццикла;
	Элементы.ТЧЗадачи.Обновить();
КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ИзменитьСтатусДляВыбранныхЗадачНаСервере(НовыйСтатус, МассивЗадач)
	Для каждого пЗадача из МассивЗадач цикл
		#Если Тромбон тогда
			пЗадача = Справочники.узЗадачи.ПустаяСсылка();
		#Конецесли
		СпрОбъект = пЗадача.ПолучитьОбъект();
		СпрОбъект.Статус = НовыйСтатус;
		СпрОбъект.Записать();
	Конеццикла;	
КонецПроцедуры 


&НаКлиенте
Процедура КомандаЗагрузитьИзмененияПоЗадачам(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	Конецесли;
	
	ВремяНачала=ТекущаяДата();
	
	РезультатФункции = ЗагрузитьИзмененияИзХранилищаНаСервере();
	
	Если РезультатФункции.Отказ Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = РезультатФункции.ТекстОшибки;
		Сообщение.Сообщить();
		Возврат;
	Конецесли;
	
	ТабДокОтчет = РезультатФункции.ТабДокОтчет;
	Если ТабДокОтчет <> Неопределено Тогда
		ТабДокОтчет.Показать("Загруженная история хранилища");
	Конецесли;	
	
	ВремяКонца=ТекущаяДата();
	Сообщить("------------------------------------------------------------------");
	Сообщить("ВремяНачала -"+ВремяНачала);
	Сообщить("ВремяКонца  -"+ВремяКонца);
	Сообщить("Общее время выполнения - "+ОКР(((ВремяКонца-ВремяНачала)/60),2) +" мин.");
	Сообщить("------------------------------------------------------------------");		
КонецПроцедуры

&НаСервере
Функция ЗагрузитьИзмененияИзХранилищаНаСервере()
	Отказ = Ложь;
	
	РезультатФункции = Новый Структура();
	пКонфигурация = Объект.Конфигурация;     
	
	Если НЕ пКонфигурация.ПолучатьИзмененияИзХранилища Тогда
		Отказ = Истина;
		РезультатФункции.Вставить("Отказ",Отказ);
		РезультатФункции.Вставить("ТекстОшибки","Для указанной конфигурации, отключено получение изменений из хранилища");
		Возврат РезультатФункции;
	Конецесли;
	
	пОбработка = Обработки.узЗагрузкаИзмененийИзХранилища.Создать();
	пОбработка.Конфигурация = пКонфигурация;
	пОбработка.ВерсияС = Справочники.узИсторияКонфигураций.ПолучитьПоследнююЗагруженнуюВерсию(пКонфигурация);
	
	РезультатФункции = пОбработка.ЗагрузитьИзмененияИзХранилища();
	РезультатФункции.Вставить("Отказ",Отказ);
	
	ЗаполнитьИсториюХранилищаПоЗадачам();
	
	ЗаполнитьТЧИзмененныеОбъектыНаСервере();	
	
	Возврат РезультатФункции;
КонецФункции 


&НаКлиенте
Процедура НомерРелизаПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.ОписаниеРелиза) Тогда
		Объект.ОписаниеРелиза = Объект.НомерРелиза;
	Конецесли;
КонецПроцедуры

