#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьВидимостьЭлементовПоТипуДействия();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДействияПриИзменении(Элемент)

	УстановитьВидимостьЭлементовПоТипуДействия();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЭтапы

&НаКлиенте
Процедура ЭтапыПриАктивизацииСтроки(Элемент)

	УстановитьОтборыПоЭтапуОбщения();

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Или Копирование Тогда

		ТекущиеДанные = Элементы.Этапы.ТекущиеДанные;
		ТекущиеДанные.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);

		УстановитьОтборыПоЭтапуОбщения();

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЭтапыПередУдалением(Элемент, Отказ)

	Для Каждого ИдентификаторСтроки Из Элементы.Этапы.ВыделенныеСтроки Цикл
		СтрокаТаблицыЭтапов = Объект.Этапы.НайтиПоИдентификатору(ИдентификаторСтроки);
		УдалитьКнопкиКлавиатурыЭтапа(СтрокаТаблицыЭтапов.УникальныйИдентификатор);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКнопкиКлавиатуры

&НаКлиенте
Процедура КнопкиКлавиатурыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)

	ТекущиеДанные = Элементы.Этапы.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КнопкиКлавиатурыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ТекущиеДанныеЭтапов = Элементы.Этапы.ТекущиеДанные;
	ТекущиеДанные = Элементы.КнопкиКлавиатуры.ТекущиеДанные;

	Если ТекущиеДанныеЭтапов = Неопределено Или ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.УникальныйИдентификатор = ТекущиеДанныеЭтапов.УникальныйИдентификатор;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовПоТипуДействия()

	Элементы.Страницы.Видимость = ЗначениеЗаполнено(Объект.ТипСценария);

	Если Не Элементы.Страницы.Видимость Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.ОтправкаОтчета Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОтчеты;
	ИначеЕсли Объект.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.Общение Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОбщение;
	ИначеЕсли Объект.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.ПроизвольныйСценарий Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПроизвольныйКод;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыПоЭтапуОбщения()

	ТекущиеДанные = Элементы.Этапы.ТекущиеДанные;

	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Элементы.КнопкиКлавиатуры.ОтборСтрок = Новый ФиксированнаяСтруктура("УникальныйИдентификатор",
		ТекущиеДанные.УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура УдалитьКнопкиКлавиатурыЭтапа(ИдентификаторЭтапа)

	НайденныеСтроки = Объект.Этапы.НайтиСтроки(Новый Структура("УникальныйИдентификатор", ИдентификаторЭтапа));

	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Объект.Этапы.Удалить(НайденнаяСтрока);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти