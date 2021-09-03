﻿#Область ОписаниеКлиентскихПеременных

&НаКлиенте
Перем Ванесса;

&НаКлиенте
Перем КешРежимСовместимости;

#КонецОбласти

#Область ПрограммныйИнтерфейс

// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	Ванесса = КонтекстЯдраПараметр;

	ИмяФреймворкаВанессы = ИмяФреймворкаВанессы();
КонецПроцедуры
// } Plugin interface

&НаКлиенте
Функция ТехническаяИнформация() Экспорт
	
	Данные = Новый Структура;

	Данные.Вставить("ВерсияВанессаАДД", Ванесса.ПолучитьВерсиюОбработкиКлиент());
	Данные.Вставить("РежимСовместимости", УзнатьРежимСовместимостиКлиент("Не использовать"));

	Данные.Вставить("РежимСинхронности", ФорматВключенВыключен(Не Ванесса.ЕстьПоддержкаАсинхронныхВызовов));

	СисИнфо            = Новый СистемнаяИнформация;
	Данные.Вставить("ВерсияОСКлиент", СисИнфо.ВерсияОС);
	Данные.Вставить("ТипПлатформыКлиент", "" + СисИнфо.ТипПлатформы);
	
	Возврат ТехническаяИнформацияСервер(Данные);
КонецФункции

&НаКлиенте
Функция СообщитьТехническуюИнформацию() Экспорт
	Сообщить(ТехническаяИнформация());
КонецФункции

&НаКлиенте
Функция УзнатьРежимСовместимостиКлиент(ЗначениеПоУмолчанию) Экспорт
	Если Не ЗначениеЗаполнено(КешРежимСовместимости) Тогда
		КешРежимСовместимости = УзнатьРежимСовместимости(ЗначениеПоУмолчанию);
	КонецЕсли;

	Возврат КешРежимСовместимости;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекстовыйДокумент.УстановитьТекст(ТехническаяИнформация());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(КонтекстЯдраНаСервере(ИмяФреймворкаВанессы), ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Функция ИмяФреймворкаВанессы()

	Если СтрНайти(Ванесса.ИмяФормы, "xddTestRunner") > 0 Тогда
		Возврат "xddTestRunner";
	КонецЕсли;

	Возврат "bddRunner";

КонецФункции

&НаСервереБезКонтекста
Функция КонтекстЯдраНаСервере(Знач ИмяФреймворкаВанессы)
	Возврат ВнешниеОбработки.Создать(ИмяФреймворкаВанессы);
КонецФункции
// } Helpers

&НаСервере
Функция ТехническаяИнформацияСервер(Знач Данные) Экспорт
	
	КонтекстЯдра = КонтекстЯдраНаСервере(ИмяФреймворкаВанессы);
	
	СисИнфо            = Новый СистемнаяИнформация;

	Данные.Вставить("ВерсияПриложения", СисИнфо.ВерсияПриложения);
	Данные.Вставить("ВерсияКонфигурации", Метаданные.Версия);
	Данные.Вставить("ИмяКонфигурации", Метаданные.Имя);
	Данные.Вставить("СинонимКонфигурации", Метаданные.Синоним);
	Данные.Вставить("РежимСовместимостиИнтерфейса", Метаданные.РежимСовместимостиИнтерфейса);
	Данные.Вставить("РежимЗапуска", "" + ТекущийРежимЗапуска() + " (" + ПредставлениеСеанса() + ")");
	Данные.Вставить("ЯзыкСеанса", ТекущийЯзык());
	Данные.Вставить("ЛокализацияСеанса", ТекущийКодЛокализации());

	ТипБазы = "Клиент-серверная ИБ";
	Если ЭтоФайловаяБаза() Тогда
		ТипБазы = "Файловая ИБ";
		ОперационнаяСистема = "Операционная система: " + Данные.ТипПлатформыКлиент + " " + Данные.ВерсияОСКлиент;
	Иначе
		ОперационнаяСистема = "Операционная система (клиент): " + Данные.ТипПлатформыКлиент + " " + Данные.ВерсияОСКлиент + "
		|	- Операционная система (сервер): " + СисИнфо.ТипПлатформы + " " + СисИнфо.ВерсияОС;
	КонецЕсли;

	Данные.Вставить("ТипБазы", ТипБазы);
	Данные.Вставить("ОперационнаяСистема", ОперационнаяСистема);

	Данные.Вставить("ЕстьЗащитаОтОпасныхДействий", ФорматВключенВыключенСервер(ЕстьЗащитаОтОпасныхДействийТекущегоПользователя()));
	Данные.Вставить("Расширения", ИнформацияОбАктивныхРасширенияхСервер(КонтекстЯдра));

	Результат =
		"
		|Техническая информация:
		|	- Версия Vanessa-ADD: " + Данные.ВерсияВанессаАДД + "
		|	- Имя конфигурации: " + Данные.ИмяКонфигурации + "
		|	- Синоним конфигурации: " + Данные.СинонимКонфигурации + "
		|	- Версия конфигурации: " + Данные.ВерсияКонфигурации + "
		|	- Платформа 1С: " + Данные.ВерсияПриложения + "
		|	- Тип базы: " + Данные.ТипБазы + "
		|	- Режим запуска: " + Данные.РежимЗапуска + "
		|	- Режим совместимости (для TestManager): " + Данные.РежимСовместимости + "
		|	- Режим совместимости интерфейса (для TestManager): " + Данные.РежимСовместимостиИнтерфейса + "
		| 	- Режим синхронности: " + Данные.РежимСинхронности + "
		| 	- Защита от опасных действий: " + Данные.ЕстьЗащитаОтОпасныхДействий + "
		|	- Язык (для TestManager): " + Данные.ЯзыкСеанса + "
		|	- Локализация (для TestManager): " + Данные.ЛокализацияСеанса + "
		|	- " + Данные.ОперационнаяСистема + "
		|	- " + Данные.Расширения + "
		|";
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ЭтоФайловаяБаза()
	Возврат Найти(СтрокаСоединенияИнформационнойБазы(), "File=") > 0;
КонецФункции

&НаСервереБезКонтекста
Функция УзнатьРежимСовместимости(ЗначениеПоУмолчанию)
	Значение = ЗначениеПоУмолчанию;

	Попытка
		Значение = Строка(Вычислить("Метаданные.РежимСовместимости"));
	Исключение
		Возврат Значение;
	КонецПопытки;

	Возврат Значение;

КонецФункции

&НаСервереБезКонтекста
//Возвращает (Строка) - имя приложения (Контекст сеанса) или представление имени приложения
Функция ПредставлениеСеанса()
	НомерСоединения  = НомерСоединенияИнформационнойБазы();
	Возврат ПолучитьИмяПриложенияТекущегоСоединения(НомерСоединения, Истина);
КонецФункции

&НаСервереБезКонтекста
//Функция ПолучитьИмяПриложенияСеанса(НомерСоединения, Представление = Ложь)
//НомерСоединения (Число) номер соединения по которому необходимо получить контекст сеанса
//Представление (Булево) - если Истина то функция вернет представления контекста сеанса (удобочитаемое)
//Пример ИмяПриложения: "WebServerExtension" Представление:"Модуль расширения веб-сервера"
//Возвращает (Строка) - имя приложения (Контекст сеанса) или представление имени приложения
//
Функция ПолучитьИмяПриложенияТекущегоСоединения(НомерСоединения, Представление = Ложь) Экспорт
    ИмяПриложения = "";

    СеансыИБ         = ПолучитьСеансыИнформационнойБазы();
    Для Каждого Сеанс Из СеансыИБ Цикл
        Если Сеанс.НомерСоединения = НомерСоединения Тогда
            Если Представление Тогда
				ИмяПриложения = ПредставлениеПриложения(Сеанс.ИмяПриложения);
			Иначе
				ИмяПриложения = Сеанс.ИмяПриложения;
			КонецЕсли;
        КонецЕсли;
    КонецЦикла;

    Возврат ИмяПриложения;

КонецФункции

&НаСервереБезКонтекста
Функция ЕстьЗащитаОтОпасныхДействийТекущегоПользователя() Экспорт
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь()
		.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
КонецФункции

&НаКлиенте
Функция ФорматВключенВыключен(БулевоЗначение)
	Возврат Формат(БулевоЗначение, "БЛ=выключен; БИ=включен");
КонецФункции

&НаСервереБезКонтекста
Функция ФорматВключенВыключенСервер(БулевоЗначение)
	Возврат Формат(БулевоЗначение, "БЛ=выключен; БИ=включен");
КонецФункции

&НаСервереБезКонтекста
Функция ИнформацияОбАктивныхРасширенияхСервер(Знач КонтекстЯдра)

	Результат = "Активные расширения:";
	
	Для Каждого ЭлементСписка Из СписокРасширений(КонтекстЯдра) Цикл
		Результат = Результат + СтрШаблон("%3	- - Расширение: %1 -- %2", ЭлементСписка.Значение, ЭлементСписка.Представление, Символы.ПС);
	КонецЦикла;

	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция СписокРасширений(Знач КонтекстЯдра) Экспорт
	
	Результат = Новый СписокЗначений();
	
	ПроверятьАктивностьРасширений = КонтекстЯдра.ПодходящийРежимСовместимостиПлатформы("8.3.12");

	Для Каждого РасширениеКонфигурации Из РасширенияКонфигурации.Получить() Цикл
		Если ПроверятьАктивностьРасширений И Не РасширениеКонфигурации.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		ПредставлениеРасширения = ПредставлениеРасширения(РасширениеКонфигурации);
		Результат.Добавить(РасширениеКонфигурации.Имя, ПредставлениеРасширения);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеРасширения(РасширениеКонфигурации)
	
	ПредставлениеБезопасногоРежима = "Безопасный режим ";
	Если РасширениеКонфигурации.БезопасныйРежим Тогда
		Суффикс = "включен";
	Иначе
		Суффикс = "не задан";
	КонецЕсли;
	ПредставлениеБезопасногоРежима = ПредставлениеБезопасногоРежима + Суффикс;
	
	Если ЗначениеЗаполнено(РасширениеКонфигурации.Версия) Тогда
		
		Представление = СтрШаблон("%1 (%2)", РасширениеКонфигурации.Синоним, РасширениеКонфигурации.Версия);
		
	Иначе
		
		Представление = РасширениеКонфигурации.Синоним;
		
	КонецЕсли;
	
	Возврат СтрШаблон("%1 - %2", Представление, ПредставлениеБезопасногоРежима);
	
КонецФункции

#КонецОбласти
