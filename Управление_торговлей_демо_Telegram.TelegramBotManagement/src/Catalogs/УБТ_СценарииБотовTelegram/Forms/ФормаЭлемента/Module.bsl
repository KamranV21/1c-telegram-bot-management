#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОпределитьДоступностьЭлементаДляРедактирования();

	УстановитьВидимостьЭлементовПоТипуДействия();

	ОпределитьДоступныеРасширенияОтчетов();
	ЗаполнитьПредставлениеРасширенийОтчетов();

	НастроитьЭлементыРегламентногоЗадания();
	УстановитьНадписьРасписания();

	ОпределитьИмяПоляHTML();
	УБТ_КонсольКодаВызовСервера.ПриСозданииНаСервере(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УБТ_КонсольКодаКлиент.ПриОткрытии(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	ИнициализироватьРегламентноеЗадание(ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если Объект.ТипСценария <> Перечисления.УБТ_ТипыСценариевБотовTelegram.ОтправкаОтчета Тогда
		Возврат;
	КонецЕсли;

	Для Каждого СтрокаТабличнойЧасти Из Объект.Отчеты Цикл

		СтруктураПоиска = Новый Структура("УникальныйИдентификатор", СтрокаТабличнойЧасти.УникальныйИдентификатор);
		НайденныеРасширения = Объект.РасширенияОтчетов.НайтиСтроки(СтруктураПоиска);

		Если НайденныеРасширения.Количество() > 0 Тогда
			Продолжить;
		КонецЕсли;

		ТекстСообщения = НСтр(
			"az = 'Hesabatın göndərilməsi üçün ən azı bir genişləndirməni göstərin.';en = 'Specify at least one extension in which the report should be sent.';ru = 'Укажите как минимум одно расширение, в котором следует отправить отчет.'");
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.Отчеты", СтрокаТабличнойЧасти.НомерСтроки,
			"Расширения");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	УстановитьПривилегированныйРежим(Истина);

	ТекущийОбъект.ВключитьОтключитьРегламентноеЗадание(РасписаниеРегламентногоЗадания);

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	ЗаполнитьПредставлениеРасширенийОтчетов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипДействияПриИзменении(Элемент)

	УстановитьВидимостьЭлементовПоТипуДействия();
	ОпределитьИмяПоляHTML();

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьРегламентноеЗаданиеПриИзменении(Элемент)

	НастроитьЭлементыРегламентногоЗадания();

КонецПроцедуры

&НаКлиенте
Процедура ИнтервалОбменаССайтомПриИзменении(Элемент)

	УстановитьРасписаниеРегламентногоЗадания();
	УстановитьНадписьРасписания();

КонецПроцедуры

&НаКлиенте
Процедура ПроизвольныйКодДокументСформирован(Элемент)

	УБТ_КонсольКодаКлиент.ConsoleOnReady(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("ОбнулитьМетаданные", 1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПроизвольныйКодПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	УБТ_КонсольКодаКлиент.ConsoleOnClick(ЭтотОбъект, ДанныеСобытия);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтчеты

&НаКлиенте
Процедура ОтчетыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Или Копирование Тогда

		ТекущиеДанные = Элементы.Отчеты.ТекущиеДанные;
		ТекущиеДанные.УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтчетыПередУдалением(Элемент, Отказ)

	Для Каждого ИдентификаторСтроки Из Элементы.Отчеты.ВыделенныеСтроки Цикл
		СтрокаТаблицыОтчетов = Объект.Отчеты.НайтиПоИдентификатору(ИдентификаторСтроки);
		УдалитьРасширенияОтчета(СтрокаТаблицыОтчетов.УникальныйИдентификатор);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОтчетыРасширенияНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	ТекущиеДанные = Элементы.Отчеты.ТекущиеДанные;

	ВыбратьРасширенияОтчета(ТекущиеДанные.УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ОтчетыРасширенияОчистка(Элемент, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.Отчеты.ТекущиеДанные;

	УдалитьРасширенияОтчета(ТекущиеДанные.УникальныйИдентификатор);

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

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьОдноразовыйПароль(Команда)

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр(
			"az = 'Dəyişiklikləri əvvəlcədən qeyd edin.';en = 'Save the changes first.';ru = 'Предварительно сохраните изменения.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Сценарий", Объект.Ссылка);

	ОткрытьФорму("РегистрСведений.УБТ_ОдноразовыеПаролиАвторизацииЧатовTelegram.Форма.ОдноразовыйПароль",
		ПараметрыФормы, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)

	ВыполнитьНастройкуРасписания();

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКод(Команда)

	Код = УБТ_КонсольКодаКлиент.ТекстHTMLПоля(ЭтотОбъект, Истина);
	Результат = УБТ_КонсольКодаВызовСервера.ВыполнитьКодНаСервере(Код, ПоказыватьЗначенияПеременныхПослеВыполнения);
	УБТ_КонсольКодаКлиент.ОбработатьРезультатВыполнения(ЭтотОбъект, Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РасширенияОтчетов

&НаКлиенте
Процедура ВыбратьРасширенияОтчета(ИдентификаторОтчета)

	СтруктураПоиска = Новый Структура("УникальныйИдентификатор", ИдентификаторОтчета);

	Найденные = Объект.РасширенияОтчетов.НайтиСтроки(СтруктураПоиска);

	ДоступныеРасширенияОтчетов.ЗаполнитьПометки(Ложь);
	Если Найденные.Количество() > 0 Тогда
		Для Каждого СтрокаРасширение Из Найденные Цикл
			ЭлементРасширения = ДоступныеРасширенияОтчетов.НайтиПоЗначению(СтрокаРасширение.Расширение);
			Если ЭлементРасширения = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ЭлементРасширения.Пометка = Истина;
		КонецЦикла;
	КонецЕсли;

	ЗаголовокДиалога = НСтр(
		"az = 'Hesabat genişləndirmələri seçin';en = 'Select report extensions';ru = 'Выберите расширения отчета'");

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИдентификаторОтчета", ИдентификаторОтчета);

	Обработчик = Новый ОписаниеОповещения("ВыбратьРасширенияОтчетаЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	ДоступныеРасширенияОтчетов.ПоказатьОтметкуЭлементов(Обработчик, ЗаголовокДиалога);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРасширенияОтчетаЗавершение(ВыбранныеРасширения, ДополнительныеПараметры) Экспорт

	Если ВыбранныеРасширения = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИдентификаторОтчета = ДополнительныеПараметры.ИдентификаторОтчета;
	УдалитьРасширенияОтчета(ИдентификаторОтчета);

	ПредставлениеВыбранныхРасширений = "";

	Для Каждого ЭлементРасширения Из ВыбранныеРасширения Цикл

		Если Не ЭлементРасширения.Пометка Тогда
			Продолжить;
		КонецЕсли;

		СтрокаФормат = Объект.РасширенияОтчетов.Добавить();
		СтрокаФормат.УникальныйИдентификатор  = ИдентификаторОтчета;
		СтрокаФормат.Расширение = ЭлементРасширения.Значение;
		ПредставлениеВыбранныхРасширений = ПредставлениеВыбранныхРасширений + ?(ПредставлениеВыбранныхРасширений = "",
			"", ", ") + ЭлементРасширения.Представление;

	КонецЦикла;

	СтруктураПоиска = Новый Структура("УникальныйИдентификатор", ИдентификаторОтчета);
	НайденныеСтроки = Объект.Отчеты.НайтиСтроки(СтруктураПоиска);
	Если НайденныеСтроки.Количество() = 1 Тогда
		НайденныеСтроки[0].Расширения = ПредставлениеВыбранныхРасширений;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьРасширенияОтчета(ИдентификаторОтчета)

	Модифицированность = Истина;

	СтруктураПоиска = Новый Структура("УникальныйИдентификатор", ИдентификаторОтчета);

	НайденныеРасширения = Объект.РасширенияОтчетов.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаРасширение Из НайденныеРасширения Цикл
		Объект.РасширенияОтчетов.Удалить(СтрокаРасширение);
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеРасширенийОтчетов()

	Для Каждого СтрокаОтчета Из Объект.Отчеты Цикл

		СтруктураПоиска = Новый Структура("УникальныйИдентификатор", СтрокаОтчета.УникальныйИдентификатор);

		ПредставлениеВыбранныхРасширений = "";

		НайденныеРасширения = Объект.РасширенияОтчетов.НайтиСтроки(СтруктураПоиска);
		Для Каждого СтрокаРасширение Из НайденныеРасширения Цикл

			ЭлементРасширения = ДоступныеРасширенияОтчетов.НайтиПоЗначению(СтрокаРасширение.Расширение);
			Если ЭлементРасширения = Неопределено Тогда
				Возврат;
			КонецЕсли;

			ПредставлениеВыбранныхРасширений = ПредставлениеВыбранныхРасширений + ?(ПредставлениеВыбранныхРасширений
				= "", "", ", ") + ЭлементРасширения.Представление;

		КонецЦикла;

		СтрокаОтчета.Расширения = ПредставлениеВыбранныхРасширений;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступныеРасширенияОтчетов()

	ДоступныеРасширенияОтчетов = Новый СписокЗначений;

	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "HTML");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "PDF");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "XLSX");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "XLS");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "ODS");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "MXL");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "DOCX");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "TXT");
	УстановитьПараметрыФормата(ДоступныеРасширенияОтчетов, "ANSITXT");

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыФормата(СписокФорматов, Расширение, Картинка = Неопределено,
	ИспользоватьПоУмолчанию = Неопределено)

	ЭлементСписка = СписокФорматов.НайтиПоЗначению(Расширение);

	Если ЭлементСписка = Неопределено Тогда
		ЭлементСписка = СписокФорматов.Добавить(Расширение, Расширение, Ложь, БиблиотекаКартинок.ФорматПустой);
	КонецЕсли;

	Если Картинка <> Неопределено Тогда
		ЭлементСписка.Картинка = Картинка;
	КонецЕсли;

	Если ИспользоватьПоУмолчанию <> Неопределено Тогда
		ЭлементСписка.Пометка = ИспользоватьПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ЭтапыОбщения

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

	НайденныеСтроки = Объект.КнопкиКлавиатуры.НайтиСтроки(Новый Структура("УникальныйИдентификатор",
		ИдентификаторЭтапа));

	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Объект.КнопкиКлавиатуры.Удалить(НайденнаяСтрока);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Расписание

&НаСервере
Процедура ИнициализироватьРегламентноеЗадание(Знач ТекущийОбъект)

	Задание = ТекущийОбъект.СуществующееЗадание();

	Если Не Задание = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Задание.Расписание;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНастройкуРасписания()

	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;

	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписание", ЭтотОбъект);

	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписание(Результат, Параметры) Экспорт

	Если ТипЗнч(Результат) = Тип("РасписаниеРегламентногоЗадания") Тогда
		РасписаниеРегламентногоЗадания = Результат;

		УстановитьНадписьРасписания();

		Модифицированность = Истина;

	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыРегламентногоЗадания()

	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаАвтообменСтраницы.ТекущаяСтраница = Элементы.ГруппаАвтообменСтраница;
	Иначе
		Элементы.ГруппаАвтообменСтраницы.ТекущаяСтраница = Элементы.ГруппаАвтообменСтраницаИнтервал;
	КонецЕсли;

	Элементы.НастроитьРасписание.Доступность = Объект.ИспользоватьРегламентноеЗадание;
	Элементы.ИнтервалОбмена.Доступность = Объект.ИспользоватьРегламентноеЗадание;
	Элементы.ПользовательРегламентногоЗадания.Доступность = Объект.ИспользоватьРегламентноеЗадание;
	Элементы.Чаты.Видимость = Объект.ИспользоватьРегламентноеЗадание;

КонецПроцедуры

&НаКлиенте
// Заполняет значения расписания регламентного задания.
//
Процедура УстановитьРасписаниеРегламентногоЗадания()

	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);

	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);

	ПериодПовтораВТечениеДня = ПериодПовтораВТечениеДня();

	Если ПериодПовтораВТечениеДня > 0 Тогда

		Расписание = Новый РасписаниеРегламентногоЗадания;
		//@skip-check bsl-legacy-check-dynamic-feature-access
		Расписание.Месяцы = Месяцы;
		//@skip-check bsl-legacy-check-dynamic-feature-access
		Расписание.ДниНедели = ДниНедели;
		//@skip-check bsl-legacy-check-dynamic-feature-access
		Расписание.ПериодПовтораВТечениеДня = ПериодПовтораВТечениеДня; // секунды
		//@skip-check bsl-legacy-check-dynamic-feature-access
		Расписание.ПериодПовтораДней = 1; // каждый день

		РасписаниеРегламентногоЗадания = Расписание;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Функция возвращает соответствие надписей выбора к количеству секунд
// 
Функция СоответствиеЗначенийВыбораККоличествуСекунд()

	СоответствиеНадписей = Новый Соответствие;
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 5 minutes'; ru = 'Один раз в 5 минут'; az = 'Bir dəfə hər 5 dəqiqə'"), 300);
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 15 minutes'; ru = 'Один раз в 15 минут'; az = 'Bir dəfə hər 15 dəqiqə'"), 900);
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 30 minutes'; ru = 'Один раз в 30 минут'; az = 'Bir dəfə hər 30 dəqiqə'"), 1800);
	СоответствиеНадписей.Вставить(НСтр("en = 'Once every hour'; ru = 'Один раз каждый час'; az = 'Bir dəfə hər saat'"),
		3600);
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 3 hour'; ru = 'Один раз в 3 часа'; az = 'Bir dəfə hər 3 saat'"), 10800);
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 6 hour'; ru = 'Один раз в 6 часов'; az = 'Bir dəfə hər 6 saat'"), 21600);
	СоответствиеНадписей.Вставить(НСтр(
		"en = 'Once every 12 hour'; ru = 'Один раз в 12 часов'; az = 'Bir dəfə hər 12 saat'"), 43200);

	Возврат СоответствиеНадписей;

КонецФункции

&НаКлиенте
// Функция возвращает ПериодПовтораВТечениеДня в секундах
//
Функция ПериодПовтораВТечениеДня()

	ЗначенияВыбора = СоответствиеЗначенийВыбораККоличествуСекунд();

	ПериодПовтораВТечениеДня = ЗначенияВыбора.Получить(ИнтервалОбмена);
	Возврат ?(ПериодПовтораВТечениеДня = Неопределено, 1800, ПериодПовтораВТечениеДня);

КонецФункции

&НаСервере
Процедура УстановитьНадписьРасписания()

	Если Не ОбщегоНазначения.РазделениеВключено() Тогда

		Если РасписаниеРегламентногоЗадания = Неопределено Тогда
			ТекстЗаголовка = НСтр("en = 'Set up a schedule'; ru = 'Настроить расписание'; az = 'Cədvəli qurmaq'");
		Иначе
			ТекстЗаголовка = РасписаниеРегламентногоЗадания;
		КонецЕсли;

		Элементы.НастроитьРасписание.Заголовок = ТекстЗаголовка;

	Иначе

		Если РасписаниеРегламентногоЗадания = Неопределено Тогда

			ИнтервалОбмена = НСтр(
				"en = 'Once every 30 minutes'; ru = 'Один раз в 30 минут'; az = 'Bir dəfə hər 30 dəqiqə'");

		Иначе

			ЗначениеПериода = РасписаниеРегламентногоЗадания.ПериодПовтораВТечениеДня;
			Если ЗначениеПериода = 0 Тогда

				ИнтервалОбмена = НСтр(
					"en = 'Once every 30 minutes'; ru = 'Один раз в 30 минут'; az = 'Bir dəfə hər 30 dəqiqə'");

			ИначеЕсли ЗначениеПериода <= 300 Тогда

				ИнтервалОбмена = НСтр(
					"en = 'Once every 5 minutes'; ru = 'Один раз в 5 минут'; az = 'Bir dəfə hər 5 dəqiqə'");

			ИначеЕсли ЗначениеПериода <= 900 Тогда

				ИнтервалОбмена = НСтр(
					"en = 'Once every 15 minutes'; ru = 'Один раз в 15 минут'; az = 'Bir dəfə hər 15 dəqiqə'");

			ИначеЕсли ЗначениеПериода <= 1800 Тогда

				ИнтервалОбмена = НСтр(
					"en = 'Once every 30 minutes'; ru = 'Один раз в 30 минут'; az = 'Bir dəfə hər 30 dəqiqə'");

			ИначеЕсли ЗначениеПериода <= 3600 Тогда

				ИнтервалОбмена = НСтр("en = 'Once every hour'; ru = 'Один раз в час'; az = 'Bir dəfə hər saat'");

			ИначеЕсли ЗначениеПериода <= 10800 Тогда

				ИнтервалОбмена = НСтр("en = 'Once every 3 hour'; ru = 'Один раз в 3 часа'; az = 'Bir dəfə hər 3 saat'");

			ИначеЕсли ЗначениеПериода <= 21600 Тогда

				ИнтервалОбмена = НСтр("en = 'Once every 6 hour'; ru = 'Один раз в 6 часов'; az = 'Bir dəfə hər 6 saat'");
			ИначеЕсли ЗначениеПериода <= 43200 Тогда

				ИнтервалОбмена = НСтр(
					"en = 'Once every 12 hour'; ru = 'Один раз в 12 часов'; az = 'Bir dəfə hər 12 saat'");
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область КонсольКода

&НаКлиенте
Процедура ОбнулитьМетаданные() Экспорт
	
	УБТ_КонсольКодаКлиент.ОбнулитьМетаданные(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОпределитьДоступностьЭлементаДляРедактирования()

	Если Объект.Ссылка = Справочники.УБТ_СценарииБотовTelegram.СценарийАвторизацииЧатов() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовПоТипуДействия()

	Элементы.СтраницыСценария.Видимость = ЗначениеЗаполнено(Объект.ТипСценария);

	Если Не Элементы.СтраницыСценария.Видимость Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ТипСценария = Перечисления.УБТ_ТипыСценариевБотовTelegram.ОтправкаОтчета Тогда
		Элементы.СтраницыСценария.ТекущаяСтраница = Элементы.СтраницаОтчеты;
	ИначеЕсли Объект.ТипСценария = Перечисления.УБТ_ТипыСценариевБотовTelegram.Общение Тогда
		Элементы.СтраницыСценария.ТекущаяСтраница = Элементы.СтраницаОбщение;
	ИначеЕсли Объект.ТипСценария = Перечисления.УБТ_ТипыСценариевБотовTelegram.ПроизвольныйСценарий Тогда
		Элементы.СтраницыСценария.ТекущаяСтраница = Элементы.СтраницаПроизвольныйКод;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОпределитьИмяПоляHTML()

	Если Объект.ТипСценария = Перечисления.УБТ_ТипыСценариевБотовTelegram.Общение Тогда
		ИмяПоляHTML = "ЭтапыПроизвольныйКод";
	Иначе
		ИмяПоляHTML = "ПроизвольныйКод";
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти