﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов	
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);	
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства	
	
	// СтандартныеПодсистемы.Взаимодействие
	// Учесть возможность создания из взаимодействия.
	Взаимодействия.ПодготовитьОповещения(ЭтотОбъект,Параметры,Ложь);
	// Конец СтандартныеПодсистемы.Взаимодействие
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьРеквизитыПоУмолчанию();
	КонецЕсли;
	
	КомментарииПометка = Ложь;
	Для каждого СтрокаКомментарии из Объект.Комментарии цикл
		Если СтрокаКомментарии.Выполнено Тогда
			Продолжить;
		Конецесли;
		КомментарииПометка = Истина;
	Конеццикла;
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.Markdown") Тогда
		Если ЗначениеЗаполнено(Объект.ТекстСодержания) Тогда
			Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаПросмотр;
		Иначе
			Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаТекст;
		Конецесли;
	Конецесли;	
	
	ВыполнитьЛокализацию();
	Элементы.КомандаПоказатьСкрытьКомментарии.Пометка = КомментарииПометка;	
	УстановитьВидимостьДоступность();
	УстановитьПараметрыИзмененныеОбъекты();
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЛокализацию()
	МассивКодовСообщений = Новый Массив();
	МассивКодовСообщений.Добавить(18); //Добавить вопрос
	МассивКодовСообщений.Добавить(19); //Изменить версию
	МассивКодовСообщений.Добавить(20); //Только список измененных объектов
	МассивКодовСообщений.Добавить(21); //Полное имя метаданных
	МассивКодовСообщений.Добавить(37); //Содержание
	МассивКодовСообщений.Добавить(38); //Вопросы и ответы
	МассивКодовСообщений.Добавить(39); //История
	МассивКодовСообщений.Добавить(40); //История статусов
	МассивКодовСообщений.Добавить(41); //Измененные объекты
	МассивКодовСообщений.Добавить(42); //Список измененных объектов
	МассивКодовСообщений.Добавить(43); //Вы следите за задачей
	МассивКодовСообщений.Добавить(44); //Цвет задачи
	
	РегистрыСведений.узСловарь.ВыполнитьЛокализацию(Элементы,МассивКодовСообщений);
	
КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст") Тогда		
		ЗагрузитьИзСодержанияВФорматированныйТекст(ТекущийОбъект);
	Конецесли;
	
	ЦветЗадачиНаФорме = ТекущийОбъект.ЦветЗадачи.Получить();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзСодержанияВФорматированныйТекст(ТекущийОбъект)
	СохраненноеСодержание = ТекущийОбъект.Содержание.Получить();
	
	ФорматированныйТекст = СохраненноеСодержание;
КонецПроцедуры 

&НаСервере
Функция ПроставитьНавигационныеСсылкиДляЗадачУказанныхВСодержании(ТекстHTML)
	ЗаменитьТекстHTML = Ложь;
	пНовыйТекстHTML = Неопределено;
	
	РезультатФункции = Новый Структура();	
	РезультатФункции.Вставить("ЗаменитьТекстHTML",ЗаменитьТекстHTML);
	РезультатФункции.Вставить("НовыйТекстHTML",пНовыйТекстHTML);
	
	ЧислоУказанныхЗадач = СтрЧислоВхождений(ТекстHTML, "#");
	Если ЧислоУказанныхЗадач = 0 Тогда
		Возврат РезультатФункции;
	Конецесли;
	
	ТЗДляЗамены = Новый ТаблицаЗначений();
	ТЗДляЗамены.Колонки.Добавить("ПодстрокаПоиска");
	ТЗДляЗамены.Колонки.Добавить("ПодстрокаЗамены");
	
	пНовыйТекстHTML = ТекстHTML;
	Для НомерВхождения = 1 По ЧислоУказанныхЗадач Цикл
		
		ПозРешетка = СтрНайти(пНовыйТекстHTML, "#",,,НомерВхождения);
		ТекстНомерЗадачи = "#";
		НомерЗадачи = "";
		
		НомерСимвола = ПозРешетка + 1;
		Символ = Сред(пНовыйТекстHTML,НомерСимвола,1);
		Пока 48<= КодСимвола(Символ)  
			И  КодСимвола(Символ) <= 57 Цикл
			
			НомерЗадачи = НомерЗадачи + Символ;
			НомерСимвола = НомерСимвола + 1;
			Символ = Сред(пНовыйТекстHTML,НомерСимвола,1);
		Конеццикла;
		ТекстНомерЗадачи = "#"+НомерЗадачи; 	
		НомерЗадачи = Число(НомерЗадачи);
		
		СсылкаНаЗадачу = Справочники.узЗадачи.НайтиПоКоду(НомерЗадачи);
		Если НЕ ЗначениеЗаполнено(СсылкаНаЗадачу) Тогда
			Продолжить;
		Конецесли;
		ЗаменитьТекстHTML = Истина;
		
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(СсылкаНаЗадачу);
		
		ТекстСсылка = "<a href="+НавигационнаяСсылка+" style='text-decoration: underline'>"+ТекстНомерЗадачи+"</a>";
		
		СтрокаТЗДляЗамены = ТЗДляЗамены.Добавить();
		СтрокаТЗДляЗамены.ПодстрокаПоиска = ТекстНомерЗадачи;
		СтрокаТЗДляЗамены.ПодстрокаЗамены = ТекстСсылка;
	КонецЦикла;
	
	Для каждого СтрокаТЗДляЗамены из ТЗДляЗамены цикл
		пНовыйТекстHTML = СтрЗаменить(пНовыйТекстHTML, СтрокаТЗДляЗамены.ПодстрокаПоиска, СтрокаТЗДляЗамены.ПодстрокаЗамены);			
	Конеццикла;
	
	РезультатФункции.Вставить("ЗаменитьТекстHTML",ЗаменитьТекстHTML);
	РезультатФункции.Вставить("НовыйТекстHTML",пНовыйТекстHTML);
	Возврат РезультатФункции;
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.Взаимодействие
	ВзаимодействияКлиент.КонтактПослеЗаписи(ЭтотОбъект,Объект,ПараметрыЗаписи,"_узЗадачи");
	// Конец СтандартныеПодсистемы.Взаимодействие	
	
	Оповестить("СправочникЗадачаЗаписана");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)	
	
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст") Тогда
		ТекущийОбъект.Содержание = Новый ХранилищеЗначения(ФорматированныйТекст, Новый СжатиеДанных(9));
		
		пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		ТекущийОбъект.ТекстСодержания = пТекстСодержания;
	Конецесли;	
	
	ТекущийОбъект.ЦветЗадачи = Новый ХранилищеЗначения(ЦветЗадачиНаФорме);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если ТребоватьЗаполнитьРодителя
		И НЕ ЗначениеЗаполнено(Объект.Родитель) Тогда
		
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Ошибка! необходимо указать родителя для задачи",6);
		
		Сообщение = Новый СообщениеПользователю;		
		Сообщение.Текст = пТекстСообщения;
		Сообщение.Поле = "Объект.Родитель"; //имя реквизита 
		Сообщение.УстановитьДанные(Объект.Родитель); //Ссылка на объект ИБ
		Сообщение.Сообщить();
		Отказ = Истина;
	Конецесли;
	
	РезультатПроверкиWIPЛимит = ПроверитьWIPЛимитНаСервере();
	Если РезультатПроверкиWIPЛимит.ПревышенWIPЛимит Тогда
		Сообщить(РезультатПроверкиWIPЛимит.ТекстОшибки);
		Отказ = Истина;
	Конецесли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьWIPЛимитНаСервере() 
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	Возврат пОбъект.ПроверитьWIPЛимит();
КонецФункции 

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()	
	
	Элементы.Родитель.АвтоОтметкаНезаполненного = ТребоватьЗаполнитьРодителя;
	Элементы.Родитель.АвтоВыборНезаполненного = ТребоватьЗаполнитьРодителя;	
	Элементы.ГруппаСтраницаИзмененныеОбъектыДетали.Видимость = Ложь;
	Элементы.ГруппаСтраницаСписокИзмененныхОбъектов.Видимость = Ложь;
	Элементы.ГруппаКомментарии.Видимость = Ложь;
	Элементы.КомментарииДобавить.Видимость = Ложь;
	Элементы.КомментарииВывестиСписок.Видимость = Ложь;
	Элементы.КомментарииПереместитьВверх.Видимость = Ложь;
	Элементы.КомментарииПереместитьВниз.Видимость = Ложь;
	Элементы.ЧасыФакт.ТолькоПросмотр = Истина;
	Элементы.ГруппаСтраницаФорматированныйТекст.Видимость = Ложь;
	Элементы.ГруппаСтраницаПросмотр.Видимость = Ложь;
	Элементы.ГруппаСтраницаТекст.Видимость = Ложь;
	Элементы.ГруппаКоманднаяПанельMarkdown.Видимость = Ложь;
	
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст") Тогда
		Элементы.ГруппаСтраницаФорматированныйТекст.Видимость = Истина;
	ИначеЕсли Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.Markdown") Тогда
		Элементы.ГруппаКоманднаяПанельMarkdown.Видимость = Истина;
		Элементы.ГруппаСтраницаПросмотр.Видимость = Истина;
		Элементы.ГруппаСтраницаТекст.Видимость = Истина;
	Иначе
		Элементы.ГруппаСтраницаТекст.Видимость = Истина;
	Конецесли;
	Если ТолькоСписокИзмененныхОбъектов Тогда
		Элементы.ГруппаСтраницаСписокИзмененныхОбъектов.Видимость = Истина;	
	Иначе
	    Элементы.ГруппаСтраницаИзмененныеОбъектыДетали.Видимость = Истина;
	Конецесли;
	Если Элементы.КомандаПоказатьСкрытьКомментарии.Пометка Тогда
		Элементы.ГруппаКомментарии.Видимость = Истина;	
		Элементы.КомментарииДобавить.Видимость = Истина;
		Элементы.КомментарииВывестиСписок.Видимость = Истина;		
		Элементы.КомментарииПереместитьВверх.Видимость = Истина;
		Элементы.КомментарииПереместитьВниз.Видимость = Истина;		
	Конецесли;
	
	Элементы.ДекорацияИнформацияОСлежениеЗаЗадачей.Видимость = Ложь;
	пЕстьЛиСлежение = РегистрыСведений.узНаблюдателиЗаЗадачами.ЕстьЛиСлежениеЗаЗадачейУТекущегоПользователя(Объект.Ссылка);
	Если пЕстьЛиСлежение Тогда
		Элементы.ДекорацияИнформацияОСлежениеЗаЗадачей.Видимость = Истина;
	Конецесли;
	
	ВТДопПараметры = Новый Структура();
	ВТДопПараметры.Вставить("ФактическиеЧасы_Количество",Объект.ФактическиеЧасы.Количество());	
	ВидимостьДоступность = ПолучитьВидимостьДоступностьЭлементов(ВТДопПараметры);
	
	Элементы.ЧасыФакт.ТолькоПросмотр = ВидимостьДоступность.ЧасыФакт_ТолькоПросмотр;
	
	ОбновитьЗаголовокПоказатьСкрытьКомментарии();
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВидимостьДоступностьЭлементов(ДопПараметры) 
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ЧасыФакт_ТолькоПросмотр",ДопПараметры.ФактическиеЧасы_Количество > 0);
	
	Возврат РезультатФункции;
КонецФункции 

&НаКлиенте
Процедура УстановитьВидимостьДоступностьНаКлиенте()
	ВТДопПараметры = Новый Структура();
	ВТДопПараметры.Вставить("ФактическиеЧасы_Количество",Объект.ФактическиеЧасы.Количество());
	ВидимостьДоступность = ПолучитьВидимостьДоступностьЭлементов(ВТДопПараметры);
	
	Элементы.ЧасыФакт.ТолькоПросмотр = ВидимостьДоступность.ЧасыФакт_ТолькоПросмотр;
КонецПроцедуры 

&НаСервере
Процедура ОбновитьЗаголовокПоказатьСкрытьКомментарии()
	
	пТекстЗаголовок = узОбщийМодульСервер.ПолучитьТекстСообщения("Комментарии / Чеклист(%1)",4);
	пТекстЗаголовок = СтрШаблон(пТекстЗаголовок,Объект.Комментарии.Количество());
	
	Элементы.КомандаПоказатьСкрытьКомментарии.Заголовок = пТекстЗаголовок;
КонецПроцедуры 

&НаКлиенте
Процедура ОбновитьЗаголовокПоказатьСкрытьКомментарииНаКлиенте()
	пТекстЗаголовок = узОбщийМодульСервер.ПолучитьТекстСообщения("Комментарии / Чеклист(%1)",4);
	пТекстЗаголовок = СтрШаблон(пТекстЗаголовок,Объект.Комментарии.Количество());
	
	Элементы.КомандаПоказатьСкрытьКомментарии.Заголовок = пТекстЗаголовок;
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

&НаСервере
Процедура УстановитьПараметрыИзмененныеОбъекты()
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("Задача",Объект.Ссылка);
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("ЭтоНовый",Объект.Ссылка.Пустая());
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоКонфигурации",ЗначениеЗаполнено(КонфигурацияОтбор));
	ИзмененныеОбъекты.Параметры.УстановитьЗначениеПараметра("КонфигурацияОтбор",КонфигурацияОтбор);
	
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("Задача",Объект.Ссылка);
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("ЭтоНовый",Объект.Ссылка.Пустая());
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("ИспользоватьОтборПоКонфигурации",ЗначениеЗаполнено(КонфигурацияОтбор));
	ИзмененныеОбъектыСписок.Параметры.УстановитьЗначениеПараметра("КонфигурацияОтбор",КонфигурацияОтбор);	
КонецПроцедуры 

&НаСервере
Процедура УстановитьПараметрыВопросыИОтветы()
	ВопросыИОтветы.Параметры.УстановитьЗначениеПараметра("Задача",Объект.Ссылка);	
	ВопросыИОтветы.Параметры.УстановитьЗначениеПараметра("ЭтоНовый",Объект.Ссылка.Пустая());
КонецПроцедуры 

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
    УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


&НаКлиенте
Процедура КомментарииВКодеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("Код",Объект.Код);
	ДопПараметры.Вставить("Исполнитель",Объект.Исполнитель);
	ДопПараметры.Вставить("НомерВнешнейЗаявки",Объект.НомерВнешнейЗаявки);
	
	Объект.КомментарииВКоде = ПолучитьКомментарийВКодеНаСервере(ДопПараметры);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКомментарийВКодеНаСервере(ДопПараметры)
	Возврат Справочники.узЗадачи.ПолучитьКомментарииВКоде(ДопПараметры);
КонецФункции 

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		Возврат;
	Конецесли;
	
	УказаноВремя = Объект.СрокИсполнения - НачалоДня(Объект.СрокИсполнения);
	Если НЕ УказаноВремя Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура КомментарииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьВводКомментария", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ЭтоДобавлениеКомментария",Истина);
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаВводаКомментария",ПараметрыФормы,,,,,ОповещениеОЗакрытии);	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьВводКомментария(РезультатЗакрытия, ДопПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	Конецесли;
	Модифицированность = Истина;
	ЭтоДобавлениеКомментария = РезультатЗакрытия.ЭтоДобавлениеКомментария; 
	Если ЭтоДобавлениеКомментария Тогда
		СтрокаКомментарии = Объект.Комментарии.Добавить();
		СтрокаКомментарии.КлючСтроки = ПолучитьНовыйКлючСтрокиДляКомментария();
	Иначе
		ПараметрыОтбора=Новый Структура();
		ПараметрыОтбора.Вставить("КлючСтроки",РезультатЗакрытия.КлючСтроки);
		НайденныеСтроки = Объект.Комментарии.НайтиСтроки(ПараметрыОтбора);
		ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
		ТекстОшибки = "";
		Если ВсегоНайденныеСтроки = 1 тогда
			СтрокаКомментарии = НайденныеСтроки[0];	
		ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
			ТекстОшибки = "Ошибка! Найдено более 1 строки";
		Иначе
			ТекстОшибки = "Ошибка! Не найдена строка";
		Конецесли;
		
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТекстОшибки = ТекстОшибки  
				+" в ""Комментарии"" для ";
			Для каждого ЭлементОтбора из ПараметрыОтбора цикл
				ТекстОшибки = ТекстОшибки  
					+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
			Конеццикла;
			ВызватьИсключение ТекстОшибки;	
		Конецесли;		
	Конецесли;	
	ЗаполнитьЗначенияСвойств(СтрокаКомментарии,РезультатЗакрытия,,"КлючСтроки");
	ОбновитьЗаголовокПоказатьСкрытьКомментарииНаКлиенте();
	//Объект.Комментарии.Сортировать("ДатаКомментария УБЫВ");
КонецПроцедуры 

&НаСервере
Функция ПолучитьНовыйКлючСтрокиДляКомментария() 
	НовыйКлючСтроки = 1;
	Если Объект.Комментарии.Количество() = 0 Тогда
		Возврат НовыйКлючСтроки;
	Конецесли;
	
	ВТКомментарии = Объект.Комментарии.Выгрузить();
	ВТКомментарии.Сортировать("КлючСтроки УБЫВ");
	СтрокаВТКомментарии = ВТКомментарии[0];
	
	ПоследнийКлючСтроки = СтрокаВТКомментарии.КлючСтроки;		
	Если ЗначениеЗаполнено(ПоследнийКлючСтроки) Тогда
		НовыйКлючСтроки = ПоследнийКлючСтроки + 1;
	Конецесли;
	
	Возврат НовыйКлючСтроки;
КонецФункции 

&НаКлиенте
Процедура КомментарииПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Возврат;
	Конецесли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтрокаКомментарии = Элементы.Комментарии.ТекущиеДанные;	
	Если СтрокаКомментарии = Неопределено тогда
		Возврат;	
	Конецесли;	
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьВводКомментария", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДатаКомментария",СтрокаКомментарии.ДатаКомментария);
	ПараметрыФормы.Вставить("Автор",СтрокаКомментарии.Автор);
	ПараметрыФормы.Вставить("Комментарий",СтрокаКомментарии.Комментарий);
	ПараметрыФормы.Вставить("Выполнено",СтрокаКомментарии.Выполнено);
	ПараметрыФормы.Вставить("КлючСтроки",СтрокаКомментарии.КлючСтроки);
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаВводаКомментария",ПараметрыФормы,ЭтаФорма,,,,ОповещениеОЗакрытии,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
	Элементы.Комментарии.ЗакончитьРедактированиеСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	//ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбработатьОтветНаВопросОЗаписи", ЭтаФорма);
	//ВызватьИсключение "Надо поправить";
	//ПоказатьВопрос(ОповещениеОЗакрытии,"Перед тем как указать исполнителя, необходимо записать задачу. Продолжить?",РежимДиалогаВопрос.ДаНет,,,"Записать задачу?");	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьЗаголовокФормы();
	
	ВыполнитьДействиеДляСтраницы();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокФормы()
	Заголовок = ?(ЗначениеЗаполнено(Объект.Код), "#"+ Формат(Объект.Код,"ЧГ=0")+" ", "") + Объект.Наименование;
КонецПроцедуры 

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	ОбновитьЗаголовокФормы();
КонецПроцедуры

&НаКлиенте
Процедура Удалить_ИспользоватьФорматированиеВСодержанииПриИзменении(Элемент)
	//ПриИзмененииИспользоватьФорматированиеВСодержанииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.ГруппаСтраницаИзмененныеОбъекты Тогда
		УстановитьПараметрыИзмененныеОбъекты();
	Конецесли;
	Если ТекущаяСтраница = Элементы.ГруппаСтраницаВопросыИОтветы Тогда
		УстановитьПараметрыВопросыИОтветы();
	Конецесли;	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаСтраницаДополнительно"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоСписокИзмененныхОбъектовПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьСкрытьКомментарии(Команда)
	Элементы.КомандаПоказатьСкрытьКомментарии.Пометка = НЕ Элементы.КомандаПоказатьСкрытьКомментарии.Пометка;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура КомандаИзмененныеОбъектыДобавить(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Конфигурация) Тогда
		пТекстСообщения = узОбщийМодульСервер.ПолучитьТекстСообщения("Ошибка! сначала необходимо заполнить реквизит [Конфигурация]",5);
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = пТекстСообщения;		
		Сообщение.Поле = "Объект.Конфигурация";
		Сообщение.Сообщить();
		Возврат;
	Конецесли;
	Если Объект.Ссылка.Пустая() Тогда
		узОбщийМодульСервер.узСообщить("Ошибка! Необходимо записать элемент, перед добавлением информации об измененных объектах",7);
		Возврат;
	Конецесли;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДобавитьНовыйЭлемент",Истина);
	ПараметрыФормы.Вставить("Конфигурация",Объект.Конфигурация);
	ПараметрыФормы.Вставить("Задача",Объект.Ссылка);
	ОткрытьФорму("Справочник.узИсторияКонфигураций.Форма.ФормаЭлемента",ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "узИсторияХранилища_ЗаписанЭлемент" Тогда
		Если ТолькоСписокИзмененныхОбъектов Тогда
			Элементы.ИзмененныеОбъектыСписок.Обновить();
		Иначе
			Элементы.ИзмененныеОбъекты.Обновить();
		Конецесли;
	Конецесли;
	Если ИмяСобытия = "КомандаСледитьЗаЗадачей"
		ИЛИ ИмяСобытия = "КомандаНеСледитьЗаЗадачей" Тогда
		УстановитьВидимостьДоступность();
	Конецесли;
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
	    ОбновитьЭлементыДополнительныхРеквизитов();
	    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОткрытьВерсию(Команда)
	СтрокаИзмененныеОбъекты = Элементы.ИзмененныеОбъекты.ТекущиеДанные;	
	Если СтрокаИзмененныеОбъекты = Неопределено тогда
		Возврат;	
	Конецесли;	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Ключ",СтрокаИзмененныеОбъекты.Ссылка);
	ОткрытьФорму("Справочник.узИсторияКонфигураций.Форма.ФормаЭлемента",ПараметрыФормы);
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
    УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоУмолчанию()
	Объект.История.Очистить();
	Объект.Комментарии.Очистить();
	Объект.ФактическиеЧасы.Очистить();
	Объект.ИсторияСтатусов.Очистить();
	
	Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст");
	Объект.Автор = Пользователи.ТекущийПользователь();
	Объект.Важность = ПредопределенноеЗначение("Справочник.узВариантыВажностиЗадачи.Обычная");
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст") Тогда
		ФорматированныйТекст = Параметры.ЗначениеКопирования.Содержание.Получить();
	Конецесли;
	Если Параметры.Свойство("ПараметрыНовойЗадачи") Тогда
		ПараметрыНовойЗадачи = Параметры.ПараметрыНовойЗадачи; 	
		ЗаполнитьЗначенияСвойств(Объект,ПараметрыНовойЗадачи);
	Конецесли;
	Если Параметры.Свойство("ТребоватьЗаполнитьРодителя") Тогда
		ТребоватьЗаполнитьРодителя = Параметры.ТребоватьЗаполнитьРодителя;
	Конецесли;
	Объект.ПоказыватьВОтчетахИКанбанДоске = Истина;
КонецПроцедуры 

&НаКлиенте
Процедура КомандаОткрытьЗадачу(Команда)
	
	Если Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаФорматированныйТекст Тогда
		ТекстВыделенный = СокрЛП(Элементы.Содержание.ВыделенныйТекст);
		Если НЕ ЗначениеЗаполнено(ТекстВыделенный) Тогда
			ТекстВыделенный = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		Конецесли;
	ИначеЕсли Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаТекст Тогда
		ТекстВыделенный = СокрЛП(Элементы.ТекстСодержания.ВыделенныйТекст);
		Если НЕ ЗначениеЗаполнено(ТекстВыделенный) Тогда
			ТекстВыделенный = Объект.ТекстСодержания;
		Конецесли;
	//ИначеЕсли Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаПросмотр Тогда
	//	ТекстВыделенный = Объект.ТекстСодержания;
	//Иначе
	//	ВызватьИсключение "Ошибка! нет алгоритма для выбранной страницы "+Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница; 
	Конецесли;

	
	МассивЗадач = ПолучитьМассивЗадачПоВыбранномуТексту(ТекстВыделенный);
	Если МассивЗадач.Количество() = 0 Тогда
		узОбщийМодульСервер.узСообщить("В выделенном тексте нет задач",75);
		Возврат;
	Конецесли;
	
	Для каждого СсылкаНаЗадачу из МассивЗадач цикл
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Ключ",СсылкаНаЗадачу);
		ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаЭлемента",ПараметрыФормы);			
	Конеццикла;
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервереБезКонтекста
Функция ПолучитьМассивЗадачПоВыбранномуТексту(ТекстВыделенный) 
	Возврат узОбщийМодульСервер.ПолучитьМассивЗадачИзТекста(ТекстВыделенный);
КонецФункции 

&НаКлиенте
Процедура КомандаПолноэкранныйРежим(Команда)
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ФорматированныйТекст",ФорматированныйТекст);
	ПараметрыФормы.Вставить("ЗаголовокФормы",Заголовок);
	ОповещенияОЗакрытии = Новый ОписаниеОповещения("ВыполнитьПослеЗакрытияПолноэкранногоРежима", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.узЗадачи.Форма.ФормаПолноэкранныйРежим",
		ПараметрыФормы,,,,,
		ОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьПослеЗакрытияПолноэкранногоРежима(РезультатЗакрытия, ДопПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	Конецесли;
	
	ФорматированныйТекст = РезультатЗакрытия.ФорматированныйТекст;
	ПерезагрузимДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПерезагрузимДанныеНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры 
#КонецОбласти

#Область Учет_времени

&НаКлиенте
Процедура ФактическиеЧасыДатаНачалаПриИзменении(Элемент)
	ИзменитьЧасыФактДляСтроки(Элементы.ФактическиеЧасы.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФактическиеЧасыДатаОкончанияПриИзменении(Элемент)
	ИзменитьЧасыФактДляСтроки(Элементы.ФактическиеЧасы.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКоличествоЧасовПоРазностиДат(ДатаНач, ДатаКон)
	Часов = 0;
	
	Если ДатаКон > ДатаНач Тогда
		Часов = (ДатаКон - ДатаНач) / 3600;
	КонецЕсли; 
	
	Возврат Часов;
КонецФункции

&НаКлиенте
Процедура ИзменитьЧасыФактДляСтроки(СтрокаТЧ)
	СтрокаТЧ.ЧасыФакт = ПолучитьКоличествоЧасовПоРазностиДат(СтрокаТЧ.ДатаНачала, СтрокаТЧ.ДатаОкончания);
	ПриИзмененииЧасыФактВТЧ();
КонецПроцедуры

&НаКлиенте
Процедура ФактическиеЧасыДатаНачалаОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтрокаФактическиеЧасы = Элементы.ФактическиеЧасы.ТекущиеДанные;	
	Если СтрокаФактическиеЧасы = Неопределено тогда
		Возврат;	
	Конецесли;	
	
	СтрокаФактическиеЧасы.ДатаНачала = НачалоМинуты(ТекущаяДата());  
	Если НЕ ЗначениеЗаполнено(СтрокаФактическиеЧасы.ДатаОкончания)
		ИЛИ СтрокаФактическиеЧасы.ДатаНачала > СтрокаФактическиеЧасы.ДатаОкончания Тогда
		СтрокаФактическиеЧасы.ДатаОкончания = ПолучитьДатаОкончания(СтрокаФактическиеЧасы.ДатаНачала);
	Конецесли;
	ИзменитьЧасыФактДляСтроки(СтрокаФактическиеЧасы);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДатаОкончания(ОтДаты) 
	пДатаОкончания = НачалоМинуты(КонецМинуты(ОтДаты)+1);		
	Возврат пДатаОкончания;
КонецФункции 

&НаКлиенте
Процедура ФактическиеЧасыДатаОкончанияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СтрокаФактическиеЧасы = Элементы.ФактическиеЧасы.ТекущиеДанные;	
	Если СтрокаФактическиеЧасы = Неопределено тогда
		Возврат;	
	Конецесли;	

	СтрокаФактическиеЧасы.ДатаОкончания = ПолучитьДатаОкончания(ТекущаяДата());  
	ИзменитьЧасыФактДляСтроки(Элементы.ФактическиеЧасы.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииЧасыФактВТЧ()
	Объект.ЧасыФакт = Объект.ФактическиеЧасы.Итог("ЧасыФакт");	
	Объект.ЧасыКОплате = Объект.ЧасыФакт;
КонецПроцедуры 


&НаКлиенте
Процедура ФактическиеЧасыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		УстановитьВидимостьДоступностьНаКлиенте();
	Конецесли;
КонецПроцедуры


&НаКлиенте
Процедура ФактическиеЧасыПослеУдаления(Элемент)
	УстановитьВидимостьДоступностьНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЧасыФактПриИзменении(Элемент)
	Объект.ЧасыКОплате = Объект.ЧасыФакт;
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьВопрос(Команда)
	Если Объект.Ссылка.Пустая() Тогда
		узОбщийМодульСервер.узСообщить("Перед добавление вопроса необходимо записать эадачу",8);
		Возврат;	
	Конецесли;
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Задача",Объект.Ссылка);
	ОткрытьФорму("Справочник.узВопросыОтветы.ФормаОбъекта",ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействиеДляСтраницы();
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.Markdown") Тогда
		Если Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаПросмотр Тогда
			ПолучитьMarkdown();
		Конецесли;
	Конецесли;
КонецПроцедуры 

&НаКлиенте
Процедура ПолучитьMarkdown()
	ПолеHTML = ПолучитьHTMLMarkdownНаСервере(Объект.ТекстСодержания);
КонецПроцедуры 

&НаСервереБезКонтекста
Функция ПолучитьHTMLMarkdownНаСервере(ЗНАЧ ТекстСодержания)
	HTMLMarkdown = узОбщийМодульСервер.ПолучитьHTMLMarkdown(ТекстСодержания);	
	Возврат HTMLMarkdown;
КонецФункции

&НаКлиенте
Процедура ОформлениеТекстаПриИзменении(Элемент)
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.Markdown") Тогда
		Если ЗначениеЗаполнено(Объект.ТекстСодержания) Тогда
			Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаПросмотр;
		Иначе
			Элементы.ГруппаСтраницыОформлениеСодержания.ТекущаяСтраница = Элементы.ГруппаСтраницаТекст;
		Конецесли;
	Конецесли;		
	ОформлениеТекстаПриИзмененииНаСервере();
	ВыполнитьДействиеДляСтраницы();
КонецПроцедуры

&НаСервере
Процедура ОформлениеТекстаПриИзмененииНаСервере()
	Если Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.ФорматированныйТекст") Тогда
		ФорматированныйТекст.УстановитьHTML(Объект.ТекстСодержания,Новый Структура);
	ИначеЕсли Объект.ОформлениеТекста = ПредопределенноеЗначение("Перечисление.узОформлениеТекста.Markdown") Тогда
		пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		Объект.ТекстСодержания = пТекстСодержания;						
	Иначе
		пТекстСодержания = ПолучитьСодержаниеТекстИзФорматированногоТекста();
		Объект.ТекстСодержания = пТекстСодержания;				
	Конецесли;
	УстановитьВидимостьДоступность();
КонецПроцедуры 

&НаКлиенте
Процедура КомандаПоказатьУбратьMarkdown(Команда)
	ПоказатьMarkdown = НЕ ПоказатьMarkdown;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыОформлениеСодержанияПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ВыполнитьДействиеДляСтраницы();
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDДобавитьТаблицу(Команда)
	ТекстMD = "| Tables        | Are           | Cool  |"
	+ Символы.ПС + "| ------------- |:-------------:| -----:|"
	+ Символы.ПС + "| col 3 is      | right-aligned | $1600 |"
	+ Символы.ПС + "| col 2 is      | centered      |   $12 |"
	+ Символы.ПС + "| zebra stripes | are neat      |    $1 |";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDДобавитьЗаголовки(Команда)
	
	ТекстMD = "# This is an <h1> tag
	|## This is an <h2> tag
	|###### This is an <h6> tag";
	
	КомандаMDДобавитьШаблон(ТекстMD);	
КонецПроцедуры

&НаКлиенте
Процедура MDДобавитьПереводСтроки()
	Если ЗначениеЗаполнено(Объект.ТекстСодержания) Тогда	
		Объект.ТекстСодержания = Объект.ТекстСодержания 
			+ Символы.ПС + Символы.ПС;
	Конецесли;	
КонецПроцедуры 

&НаКлиенте
Процедура КомандаMDЖирный(Команда)
	ТекстMD = "**This text will be bold**
	|__This will also be bold__";
	
	КомандаMDДобавитьШаблон(ТекстMD);	
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDКурсив(Команда)
	ТекстMD = "*This text will be italic*
	|_This will also be italic_";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDНумерованныйСписок(Команда)
	ТекстMD = "1. Item 1
	|1. Item 2
	|1. Item 3
	|   * Item 3a
	|   * Item 3b";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDМаркерыСписок(Команда)
	ТекстMD = "* Item 1
	|* Item 2
	|	* Item 2a
	|	* Item 2b";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDДобавитьШаблон(ТекстMD)
	
	MDДобавитьПереводСтроки();
	
	Объект.ТекстСодержания = Объект.ТекстСодержания + ТекстMD;		
КонецПроцедуры 

&НаКлиенте
Процедура КомандаMDЦитата(Команда)
	ТекстMD = "As Kanye West said:
	|
	|> We're living the future so
	|> the present is our past.";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КомандаMDЗачеркнутый(Команда)
	ТекстMD = "~~This text will be strikeout~~";
	
	КомандаMDДобавитьШаблон(ТекстMD);
КонецПроцедуры

&НаКлиенте
Процедура КонфигурацияОтборПриИзменении(Элемент)
	УстановитьПараметрыИзмененныеОбъекты();
КонецПроцедуры





#КонецОбласти 

