﻿#Область ОписаниеПеременных

Перем КонтекстЯдра;
Перем Ожидаем, ИтераторМетаданных;

Перем НаборТестов;
Перем ПривилегированныеРоли;

#КонецОбласти

#Область ПрограммныйИнтерфейс

#Область ИнтерфейсТестирования

Функция КлючНастройки() Экспорт
	Возврат "ПроверкаЧтенияНеАдминистраторами";
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
	ЗагрузитьНастройки();
	
	Если Не ЗначениеЗаполнено(ПривилегированныеРоли) Или Не НужноВыполнятьТест() Тогда 
		Возврат;
	КонецЕсли;
	
	ИтераторМетаданных = КонтекстЯдра.Плагин("ИтераторМетаданных");
	ИтераторМетаданных.Инициализация(КонтекстЯдраПараметр); 	// Сброс реквизитов плагина. Необходимо сделать, т.к. плагин уже мог быть инициализирован другой тестовой обработкой	
	ИтераторМетаданных.ДополнятьЗависимымиОбъектами = Истина;   // В принципе, можно и не дополнять. Проверял работу этого флага.
	
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.Документы);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.Справочники);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.РегистрыСведений);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.Константы);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.РегистрыНакопления);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.ПланыВидовХарактеристик);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.Задачи);
	ИтераторМетаданных.ДопустимыеМетаданные.Добавить(Метаданные.БизнесПроцессы);
	
	// При ДополнятьЗависимымиОбъектами = Истина, в объектах проверки появляются и перечисления. 
	// Но настройки прав для перечислений - нет. Поэтому Перечисления исключаем.
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Перечисления); 
		
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестовПараметр, КонтекстЯдраПараметр) Экспорт
	
	НаборТестов = НаборТестовПараметр; 	// Запищем в переменную модуля, чтобы другие методы могли дополнять набор тестов
	Инициализация(КонтекстЯдраПараметр); // Все инициализируем. В т.ч. и ИтераторМетаданных
	
	НаборТестов.Добавить("Тест_РолиОпределены", Неопределено, "Есть роли с полными/администраторскими полномочиями чтения - "
		+ ЗаголовокОбщаяЧасть());
	
	// Заполним дерево тестов
	Если ЗначениеЗаполнено(ПривилегированныеРоли) Тогда 
		ИтераторМетаданных.Перечислить(ЭтотОбъект, "ПриСледующемОбъектеМетаданных", "ПриСледующемТипеМетаданных");
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьРоль(РолиСоответствие, ИмяРоли)
	
	Попытка
		РолиСоответствие.Вставить(Метаданные.Роли[ИмяРоли], Истина);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Тесты

Процедура Тест_РолиОпределены() Экспорт
	Ожидаем.Что(ПривилегированныеРоли, "Есть проверяемые роли").Заполнено();	
КонецПроцедуры

Процедура ПриСледующемТипеМетаданных(ОбъектМетаданных, Родитель) Экспорт
	
	ЗаголовокОбщаяЧасть = ЗаголовокОбщаяЧасть();
	Если Родитель = Неопределено И ТипЗнч(ОбъектМетаданных) = Тип("Строка") Тогда 
		НаборТестов.НачатьГруппу(ЗаголовокОбщаяЧасть + " " + ОбъектМетаданных);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриСледующемОбъектеМетаданных(ОбъектМетаданных, Родитель) Экспорт
	
	ПолноеИмяОбъекта = ОбъектМетаданных.ПолноеИмя();
	
	ЗаголовокОбщаяЧасть = ЗаголовокОбщаяЧасть();
	
	Если ОбъектМетаданных <> Неопределено Тогда 
		
		Сообщение = "Пропускаем из-за исключения по имени метаданного - " + 
			КонтекстЯдра.СтрШаблон_(ШаблонПредставления(), Родитель, ОбъектМетаданных.Имя);
		Если ДобавитьТестИсключениеЕслиЕстьВИсключаемойКоллекции(ОбъектМетаданных.Имя, Настройки.ИсключенияПоИмениМетаданных, 
					Сообщение, НаборТестов) Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыТеста = НаборТестов.ПараметрыТеста(ПолноеИмяОбъекта, Родитель);
		ЗаголовокТеста = "" + ОбъектМетаданных.ПолноеИмя() + ": " + ЗаголовокОбщаяЧасть;
		НаборТестов.Добавить("Тест_ПроверитьНеАдминистраторскиеПраваНаЧтение", ПараметрыТеста, ЗаголовокТеста);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Тест_ПроверитьНеАдминистраторскиеПраваНаЧтение(ПолноеИмяМетаданного, Родитель) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданного);
	
	ЧтениеДоступно = Ложь;
	Для Каждого ТекРоль Из Метаданные.Роли Цикл 
		
		Если ПривилегированныеРоли.Получить(ТекРоль) <> Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ПараметрыДоступаОбъекта = ПараметрыДоступа("Read", ОбъектМетаданных, , ТекРоль);
		Если ПараметрыДоступаОбъекта.Доступность Тогда 
			ЧтениеДоступно = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Ожидаем.Что(ЧтениеДоступно, ПолноеИмяМетаданного + " недоступно для чтения ролями без привилегий").ЕстьИстина();
	
КонецПроцедуры

Функция ЗаголовокОбщаяЧасть()
	Возврат "Проверка доступа на Чтение Не-Администраторами";
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ШаблонПредставления()
	Возврат ЗаголовокОбщаяЧасть() + " %1: %2";
КонецФункции

Функция ДобавитьТестИсключениеЕслиЕстьВИсключаемойКоллекции(Знач ЧтоИщем, Знач КоллекцияДляПоиска, Знач Сообщение,
			Знач НаборТестов)
			
	Если КонтекстЯдра.ЕстьВИсключаемойКоллекции(ЧтоИщем, КоллекцияДляПоиска) Тогда
		КонтекстЯдра.Отладка(Сообщение);
		ПараметрыТеста = НаборТестов.ПараметрыТеста(Сообщение);
		
		НаборТестов.Добавить("Тест_ПропуститьМетаданное", ПараметрыТеста, Сообщение);
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

#Область Настройки

Процедура ЗагрузитьНастройки()
	Если ЗначениеЗаполнено(Настройки) Тогда
		Возврат;
	КонецЕсли;

	ПлагинНастройки = КонтекстЯдра.Плагин("Настройки");
	ПлагинНастройки.Инициализация(КонтекстЯдра);
	
	Настройки = ПлагинНастройки.ПолучитьНастройку(КлючНастройки());
	
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
    Если ТипЗнч(Настройки) <> Тип("Структура") Then
        Настройки = НастройкиПоУмолчанию;
	Иначе
		ЗаполнитьЗначенияСвойств(НастройкиПоУмолчанию, Настройки);
        Настройки = НастройкиПоУмолчанию;
	КонецЕсли;
	
	МассивПривилегированныеРоли = Настройки.ПривилегированныеРоли;
	
	ПривилегированныеРоли = Новый Соответствие;
	Если ЗначениеЗаполнено(МассивПривилегированныеРоли) Тогда
		Для Каждого ИмяРоли Из МассивПривилегированныеРоли Цикл
			ДобавитьРоль(ПривилегированныеРоли, ИмяРоли);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

Функция НастройкиПоУмолчанию()
	
	Результат = Новый Структура;
	
	Результат.Вставить("Используется", Истина);
	Результат.Вставить("ИсключенияПоИмениМетаданных", Новый Массив);
	Результат.Вставить("ПривилегированныеРоли", ЗаполнитьПривилегированныеРолиПоУмолчанию());
	
	Возврат Результат;
КонецФункции

Функция ЗаполнитьПривилегированныеРолиПоУмолчанию()
	// Заполняем специализированные роли - это не администраторские роли и не общие роли на Чтение
	Результат = Новый Массив;
	
	Результат.Добавить("Админ");
	Результат.Добавить("Администратор");
	Результат.Добавить("ПолныеПрава");
	Результат.Добавить("АдминНСИ");
	Результат.Добавить("Тестирование");
	Результат.Добавить("РазработкаКонфигурации");
	Результат.Добавить("Обмен");
	Результат.Добавить("Пользователь"); // общая роль на Чтение
	
	Возврат Результат;
КонецФункции

Функция НужноВыполнятьТест()
	
	ЗагрузитьНастройки();
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КлючНастройки = КлючНастройки();
	
	ВыполнятьТест = Истина;
	Если ТипЗнч(Настройки) = Тип("Структура") 
		И Настройки.Свойство("Используется", ВыполнятьТест) Тогда

			Возврат ВыполнятьТест = Истина;	
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

#КонецОбласти
