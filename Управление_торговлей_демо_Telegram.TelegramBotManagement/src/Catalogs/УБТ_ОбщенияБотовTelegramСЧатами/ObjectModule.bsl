#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет этап общения с чатом.
// 
// Параметры:
//  ПараметрыВыполнения - См. Справочники.УБТ_ОбщенияБотовTelegramСЧатами.НоваяСтруктураПараметровВыполненияЭтапа
// 
// Возвращаемое значение:
//  Структура: См. УБТ_РаботаСБотамиTelegram.НоваяСтруктураРезультатаПроизвольногоКода
Функция ВыполнитьЭтап(ПараметрыВыполнения) Экспорт

	Результат = УБТ_РаботаСБотамиTelegram.НоваяСтруктураРезультатаПроизвольногоКода();

	ВыполнитьПроизвольныйКод(ПараметрыВыполнения.ПроизвольныйКод, ПараметрыВыполнения, Результат);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет произвольный код в безопасном режиме.
// 
// Параметры:
//  ПроизвольныйКод - Строка - Произвольный код
//  Параметры - Структура: См. Справочники.УБТ_ОбщенияБотовTelegramСЧатами.НоваяСтруктураПараметровВыполненияЭтапа - Параметры выполнения
//  Результат - Неопределено, Структура: См. Справочники.УБТ_ОбщенияБотовTelegramСЧатами.НоваяСтруктураПараметровВыполненияЭтапа - Результат
Процедура ВыполнитьПроизвольныйКод(ПроизвольныйКод, Параметры, Результат = Неопределено) Экспорт

	УстановитьБезопасныйРежим(Истина);

	Если ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.БазоваяФункциональность") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МассивРазделителей = МодульРаботаВМоделиСервиса.РазделителиКонфигурации();
	Иначе
		МассивРазделителей = Новый Массив;
	КонецЕсли;

	Для Каждого ИмяРазделителя Из МассивРазделителей Цикл
		УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
	КонецЦикла;

	Выполнить (ПроизвольныйКод);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Завершает этап общения.
// 
// Параметры:
//  НаименованиеЭтапа - Строка - Наименование этапа
Процедура ЗавершитьЭтап(НаименованиеЭтапа) Экспорт

	СтруктураПоиска = Новый Структура("НаименованиеЭтапа, Завершено", НаименованиеЭтапа, Ложь);
	НайденныеСтроки = Этапы.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	СтрокаЭтапа = НайденныеСтроки[0];
	СтрокаЭтапа.Завершено = Истина;

	СтруктураПоиска = Новый Структура("Завершено", Ложь);
	Завершено = Этапы.НайтиСтроки(СтруктураПоиска).Количество() = 0;

КонецПроцедуры

// Сохраняет значение общения с чатом.
// 
// Параметры:
//  Ключ - Строка - Ключ
//  Значение - Произвольный - Значение
Процедура СохранитьЗначениеОбщения(Ключ, Значение) Экспорт

	СтруктураСохраненныхЗначений = ХранилищеЗначений.Получить();

	Если Не ЗначениеЗаполнено(СтруктураСохраненныхЗначений) Тогда
		СтруктураСохраненныхЗначений = Новый Структура;
	КонецЕсли;

	СтруктураСохраненныхЗначений.Вставить(Ключ, Значение);

	ХранилищеЗначений = Новый ХранилищеЗначения(СтруктураСохраненныхЗначений, Новый СжатиеДанных(9));

КонецПроцедуры

// Сохраняет значение общения с чатом в массиве.
// 
// Параметры:
//  Ключ - Строка - Ключ
//  Значение - Произвольный - Значение
Процедура СохранитьЗначениеОбщенияВМассиве(Ключ, Значение) Экспорт

	СтруктураСохраненныхЗначений = ХранилищеЗначений.Получить();

	Если Не ЗначениеЗаполнено(СтруктураСохраненныхЗначений) Тогда
		СтруктураСохраненныхЗначений = Новый Структура;
	КонецЕсли;

	Если Не СтруктураСохраненныхЗначений.Свойство(Ключ) Или ТипЗнч(СтруктураСохраненныхЗначений[Ключ]) <> Тип("Массив") Тогда
		СтруктураСохраненныхЗначений.Вставить(Ключ, Новый Массив);
	КонецЕсли;

	СтруктураСохраненныхЗначений[Ключ].Добавить(Значение);

	ХранилищеЗначений = Новый ХранилищеЗначения(СтруктураСохраненныхЗначений, Новый СжатиеДанных(9));

КонецПроцедуры

// Удаляет значение общения с чатом из массива.
// 
// Параметры:
//  Ключ - Строка - Ключ
//  Значение - Произвольный - Значение
Процедура УдалитьСохраненноеЗначениеОбщенияИзМассива(Ключ, Значение) Экспорт

	СтруктураСохраненныхЗначений = ХранилищеЗначений.Получить();

	Если Не ЗначениеЗаполнено(СтруктураСохраненныхЗначений) Или Не СтруктураСохраненныхЗначений.Свойство(Ключ)
		Или ТипЗнч(СтруктураСохраненныхЗначений[Ключ]) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;

	СтруктураСохраненныхЗначений[Ключ].Удалить(Значение);

	ХранилищеЗначений = Новый ХранилищеЗначения(СтруктураСохраненныхЗначений, Новый СжатиеДанных(9));

КонецПроцедуры

// Удалить значение общения с чатом.
// 
// Параметры:
//  Ключ - Строка - Ключ
Процедура УдалитьСохраненноеЗначениеОбщения(Ключ) Экспорт

	СтруктураСохраненныхЗначений = ХранилищеЗначений.Получить();

	Если Не ЗначениеЗаполнено(СтруктураСохраненныхЗначений) Тогда
		Возврат;
	КонецЕсли;

	СтруктураСохраненныхЗначений.Удалить(Ключ);

	ХранилищеЗначений = Новый ХранилищеЗначения(СтруктураСохраненныхЗначений, Новый СжатиеДанных(9));

КонецПроцедуры

// Возвращает структуру сохраненных значений общения с чатом. 
// Возвращаемое значение:
//  Структура - Сохраненные значения общения
Функция СохраненныеЗначенияОбщения() Экспорт

	СтруктураСохраненныхЗначений = ХранилищеЗначений.Получить();

	Если ТипЗнч(СтруктураСохраненныхЗначений) = Тип("Структура") Тогда
		Возврат СтруктураСохраненныхЗначений;
	Иначе
		Возврат Новый Структура;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецЕсли