#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИнициализироватьКомандыЧата();

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ЗаписатьКомандыЧата();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ИнициализироватьКомандыЧата();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКомандыБотов

&НаКлиенте
Процедура КомандыБотовПриИзменении(Элемент)

	Модифицированность = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьКоманды(Команда)

	Если УстановитьКомандыЧата() Тогда
		ТекстОповещения = НСтр(
			"az = 'Komandalar uğurla quruşdurulub';en = 'Commands have been successfully set';ru = 'Команды успешно установлены'");
		ПоказатьОповещениеПользователя(ТекстОповещения, , , БиблиотекаКартинок.Успешно32);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьКоманды(Команда)

	Если УдалитьКомандыЧата() Тогда
		ТекстОповещения = НСтр(
			"az = 'Komandalar silinib';en = 'Commands have been deleted';ru = 'Команды удалены'");
		ПоказатьОповещениеПользователя(ТекстОповещения, , , БиблиотекаКартинок.Успешно32);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция УстановитьКомандыЧата()

	Возврат УБТ_РаботаСБотамиTelegram.УстановитьПерсональныеКомандыЧата(Объект.Владелец, Объект.Ссылка);

КонецФункции

&НаСервере
Функция УдалитьКомандыЧата()

	Возврат УБТ_РаботаСБотамиTelegram.УдалитьПерсональныеКомандыЧата(Объект.Владелец, Объект.Ссылка);

КонецФункции

&НаСервере
Процедура ИнициализироватьКомандыЧата()

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда

		Элементы.СтраницаПерсональныеКоманды.Видимость = Ложь;

	Иначе

		Элементы.СтраницаПерсональныеКоманды.Видимость = Истина;

		НаборЗаписей = РегистрыСведений.УБТ_КомандыБотовTelegram.СоздатьНаборЗаписей();

		НаборЗаписей.Отбор.Бот.Значение = Объект.Владелец;
		НаборЗаписей.Отбор.Бот.ВидСравнения = ВидСравнения.Равно;
		НаборЗаписей.Отбор.Бот.Использование = Истина;

		НаборЗаписей.Отбор.Чат.Значение = Объект.Ссылка;
		НаборЗаписей.Отбор.Чат.ВидСравнения = ВидСравнения.Равно;
		НаборЗаписей.Отбор.Чат.Использование = Истина;

		НаборЗаписей.Прочитать();

		ЗначениеВРеквизитФормы(НаборЗаписей, "КомандыБотов");

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьКомандыЧата()

	НаборЗаписей = РеквизитФормыВЗначение("КомандыБотов");

	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.Бот = Объект.Владелец;
		Запись.Чат = Объект.Ссылка;
	КонецЦикла;

	НаборЗаписей.Записать();

КонецПроцедуры

#КонецОбласти