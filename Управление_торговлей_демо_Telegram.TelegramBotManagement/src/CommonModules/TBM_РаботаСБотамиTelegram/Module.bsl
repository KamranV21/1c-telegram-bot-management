#Область ПрограммныйИнтерфейс 

// Выполняет запуск заданий по взаимодействию с ботами Telegram.
//
// Параметры:
//  ИмяБота - Строка - Строка с именем бота.
Процедура TBM_ВзаимодействиеСБотамиTelegram(ИмяБота) Экспорт

	ИмяСобытия = ИмяСобытияВзаимодействияСБотамиTelegram();

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.TBM_ВзаимодействиеСБотамиTelegram);

	Бот = НайтиБотаTelegramПоИмени(ИмяБота);

	Если Не ЗначениеЗаполнено(Бот) Тогда

		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, Бот.Метаданные(), Бот, СтрШаблон(НСтр(
			"en = 'Bot named %1 was found'; ru = 'Не найден бот с именем %1'; az = '%1 adlı bot tapılmadı'"), ИмяБота));

		Возврат;

	КонецЕсли;

	ОбработатьПолученныеСообщенияБота(Бот);

КонецПроцедуры

// Загружает и обрабатывает все сообщения, полученные ботом.
//
// Параметры:
//  Бот - СправочникСсылка.TBM_БотыTelegram - Бот Telegram.
//
Процедура ОбработатьПолученныеСообщенияБота(Бот) Экспорт

	ПолученныеСообщения = ПолученныеСообщенияБота(Бот);

	Если ПолученныеСообщения.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ТаблицаСообщений = ПолученныеСообщенияВТаблицуЗначений(ПолученныеСообщения);
	ОтветитьНаПолученныеСообщения(Бот, ТаблицаСообщений);

КонецПроцедуры

// Устанавливает вебхук бота.
// 
// Параметры:
//  Бот - СправочникСсылка.TBM_БотыTelegram - Бот
//  ПараметрыВебхука - см. TBM_РаботаСБотамиTelegram.ПараметрыВебхука
// 
// Возвращаемое значение:
//  Булево - Установить вебхук
Функция УстановитьВебхук(Бот, ПараметрыВебхука) Экспорт

	Результат = Истина;

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Бот = Бот;
	ПараметрыHTTPЗапроса.Токен = ТокенБотаTelegram(Бот);
	ПараметрыHTTPЗапроса.ИмяМетода = "setWebhook";
	ПараметрыHTTPЗапроса.ТелоЗапроса = ОбщегоНазначения.ЗначениеВJSON(ПараметрыВебхука);

	HTTPОтвет = ВыполнитьHTTPЗапросКБоту(ПараметрыHTTPЗапроса);
	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Результат = Ложь;
		ТелоОтвета = HTTPОтвет.ПолучитьТелоКакСтроку();
		ЗначениеОтвета = ОбщегоНазначения.JSONВЗначение(ТелоОтвета);
		Если ЗначениеОтвета.Свойство("description") Тогда
			ОбщегоНазначения.СообщитьПользователю(ЗначениеОтвета.description);
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Отправляет сообщение в чат.
// 
// Параметры:
//  Бот - СправочникСсылка.TBM_БотыTelegram - Бот
//  Сообщение - Структура: см. НоваяСтруктураСообщенияЧата
// 
// Возвращаемое значение:
//  Булево - Результат отправки сообщения
Функция ОтправитьСообщениеВЧат(Бот, Сообщение) Экспорт

	Результат = Истина;

	Если Не ЗначениеЗаполнено(Сообщение.reply_markup) Тогда
		Сообщение.reply_markup = СтруктураУдаленияКлавиатуры();
	КонецЕсли;

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Бот = Бот;
	ПараметрыHTTPЗапроса.Токен = ТокенБотаTelegram(Бот);
	ПараметрыHTTPЗапроса.ИмяМетода = "sendMessage";
	ПараметрыHTTPЗапроса.ТелоЗапроса = ОбщегоНазначения.ЗначениеВJSON(Сообщение);

	HTTPОтвет = ВыполнитьHTTPЗапросКБоту(ПараметрыHTTPЗапроса);
	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Отправить документ в чат.
// 
// Параметры:
//  Бот - СправочникСсылка.TBM_БотыTelegram - Бот
//  ДвоичныеДанныеСообщения - ДвоичныеДанные, Произвольный - Двоичные данные сообщения
// 
// Возвращаемое значение:
//  Булево - Отправить документ в чат
Функция ОтправитьДокументВЧат(Бот, ДвоичныеДанныеСообщения) Экспорт

	Результат = Истина;

	Разделитель = РазделительMultipartFormData();

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Бот = Бот;
	ПараметрыHTTPЗапроса.Токен = ТокенБотаTelegram(Бот);
	ПараметрыHTTPЗапроса.ИмяМетода = "sendDocument";
	ПараметрыHTTPЗапроса.Заголовки["Content-Type"] = СтрШаблон("multipart/form-data; boundary=%1", Разделитель);
	ПараметрыHTTPЗапроса.ТелоЗапросаДвоичныеДанные = ДвоичныеДанныеСообщения;

	HTTPОтвет = ВыполнитьHTTPЗапросКБоту(ПараметрыHTTPЗапроса);
	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Результат = Ложь;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает токен бота Telegram.
// 
// Параметры:
//  Бот - СправочникСсылка.TBM_БотыTelegram - Бот
// 
// Возвращаемое значение:
//  Строка - Токен бота Telegram
Функция ТокенБотаTelegram(Бот) Экспорт

	ИдентификаторБота = Справочники.TBM_БотыTelegram.ИдентификаторЭлементаБотаСПрефиксом(Бот);

	УстановитьПривилегированныйРежим(Истина);
	Токен = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИдентификаторБота);
	УстановитьПривилегированныйРежим(Ложь);

	Если ТипЗнч(Токен) = Тип("Строка") Тогда
		Возврат Токен;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

Функция ПараметрыВебхука() Экспорт

	ПараметрыВебхука = Новый Структура;
	ПараметрыВебхука.Вставить("url", "");
	ПараметрыВебхука.Вставить("secret_token", "");

	Возврат ПараметрыВебхука;

КонецФункции

// Структура сообщения чата.
// 
// Возвращаемое значение:
//  Структура:
// * chat_id - Строка
// * text - Строка
// * reply_markup - Неопределено,Произвольный
Функция НоваяСтруктураСообщенияЧата() Экспорт

	Сообщение = Новый Структура;
	Сообщение.Вставить("chat_id", "");
	Сообщение.Вставить("text", "");
	Сообщение.Вставить("reply_markup", Неопределено);

	Возврат Сообщение;

КонецФункции

// Новая клавиатура предоределенного ответа.
// 
// Возвращаемое значение:
//  Структура - Новая клавиатура предоределенного ответа:
// * keyboard - Массив Из Массив Из См. НоваяКнопкаКлавиатуры  
// * resize_keyboard - Булево
// * one_time_keyboard - Булево
Функция НоваяКлавиатураПредоределенногоОтвета() Экспорт

	КлавиатураОтвета = Новый Структура;

	КлавиатураОтвета.Вставить("keyboard", Новый Массив);
	КлавиатураОтвета.Вставить("resize_keyboard", Истина);
	КлавиатураОтвета.Вставить("one_time_keyboard", Истина);

	Возврат КлавиатураОтвета;

КонецФункции

Функция НоваяКнопкаКлавиатуры() Экспорт

	КнопкаКлавиатуры = Новый Структура;

	КнопкаКлавиатуры.Вставить("text", "");
	КнопкаКлавиатуры.Вставить("request_contact", Ложь);

	Возврат КнопкаКлавиатуры;

КонецФункции

Функция СтруктураУдаленияКлавиатуры() Экспорт

	Возврат Новый Структура("remove_keyboard", Истина);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область HTTPЗапросы

Функция ВыполнитьHTTPЗапросКБоту(ПараметрыHTTPЗапроса)

	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();

	HTTPСоединение = Новый HTTPСоединение(ПараметрыHTTPЗапроса.БазовыйURL, , , , , ПараметрыHTTPЗапроса.Таймаут,
		ЗащищенноеСоединение);

	АдресРесурса = "/bot" + ПараметрыHTTPЗапроса.Токен + "/" + ПараметрыHTTPЗапроса.ИмяМетода;

	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, ПараметрыHTTPЗапроса.Заголовки);

	Если ЗначениеЗаполнено(ПараметрыHTTPЗапроса.ТелоЗапроса) Тогда
		HTTPЗапрос.УстановитьТелоИзСтроки(ПараметрыHTTPЗапроса.ТелоЗапроса);
	ИначеЕсли ЗначениеЗаполнено(ПараметрыHTTPЗапроса.ТелоЗапросаДвоичныеДанные) Тогда
		HTTPЗапрос.УстановитьТелоИзДвоичныхДанных(ПараметрыHTTPЗапроса.ТелоЗапросаДвоичныеДанные);
	КонецЕсли;

	Попытка

		HTTPОтвет = HTTPСоединение.ВызватьHTTPМетод(ПараметрыHTTPЗапроса.HTTPМетод, HTTPЗапрос);
		Возврат HTTPОтвет;

	Исключение

		ИмяСобытия = ИмяСобытияВзаимодействияСБотамиTelegram();

		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);

		ТекстОшибки = НСтр(
			"az = 'Telegram API ilə əlaqə qurarkən səhv. Ətraflı məlumat üçün qeydiyyat jurnalına baxın.';en = 'An error occurred when accessing the Telegram API. See the registration log for details.';ru = 'Произошла ошибка при обращении к API Telegram. Подробности смотрите в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);

		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, ПараметрыHTTPЗапроса.Бот.Метаданные(),
			ПараметрыHTTPЗапроса.Бот, СтрШаблон(НСтр("en = 'Error: %1'; ru = 'Ошибка: %1'; az = 'Səhv: %1'"),
			ПодробноеПредставлениеОшибки));

		Возврат Неопределено;

	КонецПопытки;

КонецФункции

Функция НоваяСтруктураПараметровHTTPЗапроса()

	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");

	Структура = Новый Структура;
	Структура.Вставить("Бот", Справочники.TBM_БотыTelegram.ПустаяСсылка());
	Структура.Вставить("БазовыйURL", "api.telegram.org");
	Структура.Вставить("Токен", "");
	Структура.Вставить("ИмяМетода", "");
	Структура.Вставить("HTTPМетод", "POST");
	Структура.Вставить("Заголовки", Заголовки);
	Структура.Вставить("Таймаут", 30);
	Структура.Вставить("ТелоЗапроса", "");
	Структура.Вставить("ТелоЗапросаДвоичныеДанные", Неопределено);

	Возврат Структура;

КонецФункции

#КонецОбласти

#Область ОбработкаПолученныхСообщений

Процедура ОтветитьНаПолученныеСообщения(Бот, ТаблицаСообщений)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	ТаблицаСообщений.ТекстСообщения КАК ТекстСообщения,
						  |	ТаблицаСообщений.ИмяКонтакта КАК ИмяКонтакта,
						  |	ТаблицаСообщений.НомерТелефонаКонтакта КАК НомерТелефонаКонтакта,
						  |	ТаблицаСообщений.ИдентификаторЧата КАК ИдентификаторЧата,
						  |	ТаблицаСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения
						  |ПОМЕСТИТЬ ВтТаблицаСообщений
						  |ИЗ
						  |	&ТаблицаСообщений КАК ТаблицаСообщений
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВтТаблицаСообщений.ИдентификаторЧата КАК ИдентификаторЧата,
						  |	ВтТаблицаСообщений.ИмяКонтакта КАК ИмяКонтакта,
						  |	ВтТаблицаСообщений.НомерТелефонаКонтакта КАК НомерТелефонаКонтакта,
						  |	ВтТаблицаСообщений.ТекстСообщения КАК ТекстСообщения,
						  |	ВтТаблицаСообщений.ИдентификаторСообщения КАК ИдентификаторСообщения,
						  |	ЕСТЬNULL(ПерсональныеКоманды.Сценарий, ЕСТЬNULL(ОбщиеКоманды.Сценарий,
						  |		ЗНАЧЕНИЕ(Справочник.TBM_СценарииБотовTelegram.ПустаяСсылка))) КАК Сценарий
						  |ПОМЕСТИТЬ ВтСценарии
						  |ИЗ
						  |	ВтТаблицаСообщений КАК ВтТаблицаСообщений
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TBM_КомандыБотовTelegram КАК ПерсональныеКоманды
						  |		ПО ПерсональныеКоманды.Бот = &Бот
						  |		И ВтТаблицаСообщений.ТекстСообщения = ПерсональныеКоманды.Команда
						  |		И ВтТаблицаСообщений.ИдентификаторЧата = ПерсональныеКоманды.Чат.Код
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TBM_КомандыБотовTelegram КАК ОбщиеКоманды
						  |		ПО ОбщиеКоманды.Бот = &Бот
						  |		И ВтТаблицаСообщений.ТекстСообщения = ОбщиеКоманды.Команда
						  |		И ОбщиеКоманды.Чат = ЗНАЧЕНИЕ(Справочник.TBM_ЧатыTelegram.ПустаяСсылка)
						  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.TBM_ОбработанныеСообщенияБотовTelegram КАК ОбработанныеСообщения
						  |		ПО ВтТаблицаСообщений.ИдентификаторСообщения = ОбработанныеСообщения.ИдентификаторСообщения
						  |		И ВтТаблицаСообщений.ИдентификаторЧата = ОбработанныеСообщения.Чат.Код
						  |		И ОбработанныеСообщения.Бот = &Бот
						  |ГДЕ
						  |	ОбработанныеСообщения.ИдентификаторСообщения ЕСТЬ NULL
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВтСценарии.ИдентификаторЧата КАК ИдентификаторЧата,
						  |	ВтСценарии.ТекстСообщения КАК ТекстСообщения,
						  |	ВтСценарии.ИмяКонтакта КАК ИмяКонтакта,
						  |	ВтСценарии.НомерТелефонаКонтакта КАК НомерТелефонаКонтакта,
						  |	ВтСценарии.ИдентификаторСообщения КАК ИдентификаторСообщения,
						  |	ЕСТЬNULL(ЧатыTelegram.Ссылка, ЗНАЧЕНИЕ(Справочник.TBM_ЧатыTelegram.ПустаяСсылка)) КАК Чат,
						  |	ВтСценарии.Сценарий КАК Сценарий
						  |ПОМЕСТИТЬ ВтСценарииЧаты
						  |ИЗ
						  |	ВтСценарии КАК ВтСценарии
						  |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.TBM_ЧатыTelegram КАК ЧатыTelegram
						  |		ПО ВтСценарии.ИдентификаторЧата = ЧатыTelegram.Код
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ВтСценарииЧаты.ИдентификаторЧата КАК ИдентификаторЧата,
						  |	ВтСценарииЧаты.ТекстСообщения КАК ТекстСообщения,
						  |	ВтСценарииЧаты.ИмяКонтакта КАК ИмяКонтакта,
						  |	ВтСценарииЧаты.НомерТелефонаКонтакта КАК НомерТелефонаКонтакта,
						  |	ВтСценарииЧаты.ИдентификаторСообщения КАК ИдентификаторСообщения,
						  |	ВтСценарииЧаты.Чат КАК Чат,
						  |	ВтСценарииЧаты.Сценарий КАК Сценарий,
						  |	ВтСценарииЧаты.Сценарий.ТипСценария КАК ТипСценария,
						  |	ВтСценарииЧаты.Сценарий.ПроизвольныйКод КАК ПроизвольныйКод,
						  |	ВтСценарииЧаты.Сценарий.КнопкиКлавиатуры.(
						  |		Ссылка,
						  |		НомерСтроки,
						  |		Наименование,
						  |		ЗапросНомераТелефона,
						  |		УникальныйИдентификатор) КАК КнопкиКлавиатуры,
						  |	ВтСценарииЧаты.Сценарий.Этапы.(
						  |		Ссылка,
						  |		НомерСтроки,
						  |		НаименованиеЭтапа,
						  |		ПроизвольныйКод,
						  |		УникальныйИдентификатор) КАК Этапы
						  |ИЗ
						  |	ВтСценарииЧаты КАК ВтСценарииЧаты
						  |ИТОГИ
						  |ПО
						  |	Сценарий
						  |;
						  |
						  |////////////////////////////////////////////////////////////////////////////////
						  |ВЫБРАТЬ
						  |	ЭтапыТекущегоОбщения.Ссылка КАК Общение,
						  |	ЭтапыТекущегоОбщения.Ссылка.Чат КАК Чат,
						  |	ЭтапыТекущегоОбщения.Ссылка.Сценарий КАК Сценарий,
						  |	ЭтапыТекущегоОбщения.НаименованиеЭтапа КАК НаименованиеЭтапа,
						  |	ЭтапыТекущегоОбщения.УникальныйИдентификатор КАК УникальныйИдентификатор,
						  |	ЭтапыСценария.ПроизвольныйКод КАК ПроизвольныйКод
						  |ИЗ
						  |	Справочник.TBM_ОбщенияБотовTelegramСЧатами.Этапы КАК ЭтапыТекущегоОбщения
						  |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.TBM_СценарииБотовTelegram.Этапы КАК ЭтапыСценария
						  |		ПО ЭтапыТекущегоОбщения.Ссылка.Сценарий = ЭтапыСценария.Ссылка
						  |		И ЭтапыТекущегоОбщения.УникальныйИдентификатор = ЭтапыСценария.УникальныйИдентификатор
						  |ГДЕ
						  |	ЭтапыТекущегоОбщения.Ссылка.Бот = &Бот
						  |	И ЭтапыТекущегоОбщения.Ссылка.Чат В
						  |		(ВЫБРАТЬ
						  |			Т.Чат
						  |		ИЗ
						  |			ВтСценарииЧаты КАК Т)
						  |	И НЕ ЭтапыТекущегоОбщения.Ссылка.Завершено
						  |	И НЕ ЭтапыТекущегоОбщения.Завершено
						  |
						  |УПОРЯДОЧИТЬ ПО
						  |	ЭтапыТекущегоОбщения.НомерСтроки");
	Запрос.УстановитьПараметр("ТаблицаСообщений", ТаблицаСообщений);
	Запрос.УстановитьПараметр("Бот", Бот);

	МассивРезультатов = Запрос.ВыполнитьПакет();

	ТекущиеОбщенияСЧатами = МассивРезультатов[МассивРезультатов.Количество() - 1].Выбрать();
	РезультатСценарии = МассивРезультатов[МассивРезультатов.Количество() - 2];

	ВыборкаСценарии = РезультатСценарии.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ЗавершитьНеоконченныеОбщенияСЧатами(ВыборкаСценарии, ТекущиеОбщенияСЧатами);

	Пока ВыборкаСценарии.Следующий() Цикл

		Если ВыборкаСценарии.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.ОтправкаОтчета Тогда

			ОтправитьОтчетыВЧаты(Бот, ВыборкаСценарии);

		ИначеЕсли ВыборкаСценарии.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.Общение Тогда

			ЗапуститьОбщениеСЧатом(Бот, ВыборкаСценарии);

		ИначеЕсли ВыборкаСценарии.ТипСценария = Перечисления.TBM_ТипыСценариевБотовTelegram.ПроизвольныйСценарий Тогда

			ВыполнитьСценарийИОтправитьСообщениеВЧат(Бот, ВыборкаСценарии);

		Иначе

			НовыеЧаты = Новый Соответствие;

			ВыборкаЧаты = ВыборкаСценарии.Выбрать();
			Пока ВыборкаЧаты.Следующий() Цикл

				Чат = ВыборкаЧаты.Чат;
				Если Не ЗначениеЗаполнено(Чат) Тогда
					Чат = НовыеЧаты[ВыборкаЧаты.ИдентификаторЧата];
				КонецЕсли;

				Если Чат = Неопределено Тогда
					Чат = СоздатьНовыйЧатБота(Бот, ВыборкаЧаты);
					НовыеЧаты.Вставить(ВыборкаЧаты.ИдентификаторЧата, Чат);
				КонецЕсли;

				ТекущиеОбщенияСЧатами.Сбросить();
				СтруктураПоиска = Новый Структура("Чат", ВыборкаЧаты.Чат);

				Если ТекущиеОбщенияСЧатами.НайтиСледующий(СтруктураПоиска) Тогда
					ПродолжитьОбщениеСЧатом(ВыборкаЧаты, ТекущиеОбщенияСЧатами);
				Иначе
					СообщитьОНеизвестнойКоманде(Бот, Чат, ВыборкаЧаты);
				КонецЕсли;

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ЗавершитьНеоконченныеОбщенияСЧатами(ВыборкаСценарии, ТекущиеОбщенияСЧатами)

	Пока ВыборкаСценарии.Следующий() Цикл

		ВыборкаЧаты = ВыборкаСценарии.Выбрать();

		Пока ВыборкаЧаты.Следующий() Цикл

			СтруктураПоиска = Новый Структура("Чат", ВыборкаЧаты.Чат);
			ТекущиеОбщенияСЧатами.Сбросить();
			ТекущиеОбщенияСЧатами.НайтиСледующий(СтруктураПоиска);
			ТекущееОбщениеСЧатом = ТекущиеОбщенияСЧатами.Общение;

			Если ЗначениеЗаполнено(ТекущееОбщениеСЧатом) И ЗначениеЗаполнено(ВыборкаСценарии.ТипСценария) Тогда
				ЗавершитьНеоконченноеОбщениеСЧатом(ТекущееОбщениеСЧатом);
			КонецЕсли;

		КонецЦикла;

	КонецЦикла;

	ВыборкаСценарии.Сбросить();
	ТекущиеОбщенияСЧатами.Сбросить();

КонецПроцедуры

Функция ПолученныеСообщенияБота(Бот)

	ПараметрыПолученияСообщенийКБоту = ПараметрыПолученияСообщенийКБоту(Бот);

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Бот = Бот;
	ПараметрыHTTPЗапроса.Токен = ТокенБотаTelegram(Бот);
	ПараметрыHTTPЗапроса.ИмяМетода = "getUpdates";
	ПараметрыHTTPЗапроса.ТелоЗапроса = ОбщегоНазначения.ЗначениеВJSON(ПараметрыПолученияСообщенийКБоту);

	HTTPОтвет = ВыполнитьHTTPЗапросКБоту(ПараметрыHTTPЗапроса);
	Если HTTPОтвет = Неопределено Или HTTPОтвет.КодСостояния <> 200 Тогда
		Возврат Новый Массив;
	КонецЕсли;

	Ответ = ОбщегоНазначения.JSONВЗначение(HTTPОтвет.ПолучитьТелоКакСтроку());

	Возврат Ответ.result;

КонецФункции

Функция ПараметрыПолученияСообщенийКБоту(Бот)

	ИдентификаторПоследнегоСообщения = ИдентификаторПоследнегоОбработанногоСообщения(Бот);

	ПараметрыПолученияСообщенийКБоту = Новый Структура;
	ПараметрыПолученияСообщенийКБоту.Вставить("offset", ИдентификаторПоследнегоСообщения + 1);

	Возврат ПараметрыПолученияСообщенийКБоту;

КонецФункции

Функция ПолученныеСообщенияВТаблицуЗначений(ПолученныеСообщения)

	ТаблицаСообщений = НоваяТаблицаПолученныхСообщений();

	Для Каждого ПолученноеСообщение Из ПолученныеСообщения Цикл

		Если Не ПолученноеСообщение.Свойство("message") Тогда
			Продолжить;
		КонецЕсли;

		СтрокаТаблицыСообщений = ТаблицаСообщений.Добавить();
		СтрокаТаблицыСообщений.ИдентификаторЧата = Формат(ПолученноеСообщение.message.chat.id, "ЧГ=");
		СтрокаТаблицыСообщений.ИдентификаторСообщения = ПолученноеСообщение.update_id;

		Если ПолученноеСообщение.message.Свойство("text") Тогда
			СтрокаТаблицыСообщений.ТекстСообщения = ПолученноеСообщение.message.text;
		КонецЕсли;

		Если ПолученноеСообщение.message.Свойство("contact") Тогда
			СтрокаТаблицыСообщений.ИмяКонтакта = ПолученноеСообщение.message.contact.first_name;
			СтрокаТаблицыСообщений.НомерТелефонаКонтакта = ПолученноеСообщение.message.contact.phone_number;
		КонецЕсли;

	КонецЦикла;

	Возврат ТаблицаСообщений;

КонецФункции

Функция НоваяТаблицаПолученныхСообщений()

	ТипСтрока100 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100));
	ТипСтрока50 = Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(50));
	ТипЧисло15 = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15));

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("ТекстСообщения", ТипСтрока100);
	Таблица.Колонки.Добавить("ИмяКонтакта", ТипСтрока100);
	Таблица.Колонки.Добавить("НомерТелефонаКонтакта", ТипСтрока100);
	Таблица.Колонки.Добавить("ИдентификаторЧата", ТипСтрока50);
	Таблица.Колонки.Добавить("ИдентификаторСообщения", ТипЧисло15);

	Возврат Таблица;

КонецФункции

Функция ИдентификаторПоследнегоОбработанногоСообщения(Бот)

	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
						  |	TBM_ОбработанныеСообщенияБотовTelegram.ИдентификаторСообщения КАК ИдентификаторСообщения
						  |ИЗ
						  |	РегистрСведений.TBM_ОбработанныеСообщенияБотовTelegram КАК TBM_ОбработанныеСообщенияБотовTelegram
						  |ГДЕ
						  |	TBM_ОбработанныеСообщенияБотовTelegram.Бот = &Бот
						  |
						  |УПОРЯДОЧИТЬ ПО
						  |	ИдентификаторСообщения УБЫВ");
	Запрос.УстановитьПараметр("Бот", Бот);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Возврат Выборка.ИдентификаторСообщения;
	КонецЕсли;

	Возврат 0;

КонецФункции

#КонецОбласти

#Область ОтправкаОтчетов

// Возвращает массив табличных документов по заданному сценарию.
// 
// Параметры:
//  Сценарий - СправочникСсылка.TBM_СценарииБотовTelegram - Сценарий
// 
// Возвращаемое значение:
//  Массив Из ТабличныйДокумент - Отчеты к отправке
Функция СформироватьОтчетыПоСценарию(Сценарий)

	МассивОтчетов = Новый Массив;

	ВыборкаОтчетов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий, "Отчеты").Выбрать();

	Пока ВыборкаОтчетов.Следующий() Цикл

		ПараметрыФормирования = ВариантыОтчетов.ПараметрыФормированияОтчета();
		ПараметрыФормирования.СсылкаВарианта = ВыборкаОтчетов.Отчет;

		Формирование = ВариантыОтчетов.СформироватьОтчет(ПараметрыФормирования, Истина, Истина);

		Если Формирование.Успех Тогда
			МассивОтчетов.Добавить(Формирование.ТабличныйДокумент);
		КонецЕсли;

	КонецЦикла;

	Возврат МассивОтчетов;

КонецФункции

Процедура ОтправитьОтчетыВЧаты(Бот, ВыборкаСценарии)

	ОтчетыКОтправке = СформироватьОтчетыПоСценарию(ВыборкаСценарии.Сценарий);

	ПараметрыHTTPЗапроса = НоваяСтруктураПараметровHTTPЗапроса();
	ПараметрыHTTPЗапроса.Бот = Бот;
	ПараметрыHTTPЗапроса.Токен = ТокенБотаTelegram(Бот);
	ПараметрыHTTPЗапроса.ИмяМетода = "sendDocument";
	ПараметрыHTTPЗапроса.Заголовки["Content-Type"] = СтрШаблон("multipart/form-data; boundary=%1",
		РазделительMultipartFormData());

	ВыборкаЧатов = ВыборкаСценарии.Выбрать();

	НовыеЧаты = Новый Соответствие;

	Пока ВыборкаЧатов.Следующий() Цикл

		ИдентификаторЧата = ВыборкаЧатов.ИдентификаторЧата;

		Чат = ВыборкаЧатов.Чат;
		Если Не ЗначениеЗаполнено(Чат) Тогда
			Чат = НовыеЧаты[ИдентификаторЧата];
		КонецЕсли;

		Если Чат = Неопределено Тогда
			Чат = СоздатьНовыйЧатБота(Бот, ВыборкаЧатов);
			НовыеЧаты.Вставить(ИдентификаторЧата, Чат);
		КонецЕсли;

		Для Каждого ТабличныйДокумент Из ОтчетыКОтправке Цикл

			ИмяВременногоФайла = ПолучитьИмяВременногоФайла("pdf");

			ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.PDF);

			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);

			ДвоичныеДанныеСообщения = ТелоВыгрузкиДокумента(ИдентификаторЧата, ДвоичныеДанные);
			Если ОтправитьДокументВЧат(Бот, ДвоичныеДанныеСообщения) Тогда
				СохранитьОбработанноеСообщение(Бот, Чат, ВыборкаЧатов);
			КонецЕсли;
			Попытка
				УдалитьФайлы(ИмяВременногоФайла);
			Исключение

				ИмяСобытия = ИмяСобытияВзаимодействияСБотамиTelegram();

				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);

				ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, Бот.Метаданные(), Бот, СтрШаблон(
					НСтр(
			"en = 'Error: %1'; ru = 'Ошибка: %1'; az = 'Səhv: %1'"), ПодробноеПредставлениеОшибки));

			КонецПопытки;

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Общение

Процедура ЗапуститьОбщениеСЧатом(Бот, ВыборкаСценарии)

	ВыборкаЧаты = ВыборкаСценарии.Выбрать();

	Сценарий = ВыборкаСценарии.Сценарий; // СправочникСсылка.TBM_СценарииБотовTelegram
	ЭтапыСценария = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий, "Этапы").Выбрать();

	Если Не ЭтапыСценария.Следующий() Тогда
		Возврат;
	КонецЕсли;

	НаименованиеСтартовогоЭтапа = ЭтапыСценария.НаименованиеЭтапа;
	ИдентификаторСтартовогоЭтапа = ЭтапыСценария.НаименованиеЭтапа;
	ПроизвольныйКодСтартовогоЭтапа = ЭтапыСценария.ПроизвольныйКод;

	ЭтапыСценария.Сбросить();

	НовыеЧаты = Новый Соответствие;

	Пока ВыборкаЧаты.Следующий() Цикл

		ИдентификаторЧата = ВыборкаЧаты.ИдентификаторЧата;

		Чат = ВыборкаЧаты.Чат;
		Если Не ЗначениеЗаполнено(Чат) Тогда
			Чат = НовыеЧаты[ИдентификаторЧата];
		КонецЕсли;

		Если Чат = Неопределено Тогда
			Чат = СоздатьНовыйЧатБота(Бот, ВыборкаЧаты);
			НовыеЧаты.Вставить(ИдентификаторЧата, Чат);
		КонецЕсли;

		ОбщениеОбъект = Справочники.TBM_ОбщенияБотовTelegramСЧатами.СоздатьЭлемент();
		ОбщениеОбъект.Бот = Бот;
		ОбщениеОбъект.Чат = Чат;
		ОбщениеОбъект.ИдентификаторЧата = ИдентификаторЧата;
		ОбщениеОбъект.Сценарий = Сценарий;
		ОбщениеОбъект.Дата = ТекущаяДатаСеанса();
		Пока ЭтапыСценария.Следующий() Цикл
			СтрокаЭтапа = ОбщениеОбъект.Этапы.Добавить();
			СтрокаЭтапа.НаименованиеЭтапа = ЭтапыСценария.НаименованиеЭтапа;
			СтрокаЭтапа.УникальныйИдентификатор = ЭтапыСценария.УникальныйИдентификатор;
		КонецЦикла;

		ОбщениеОбъект.Записать();

		ПараметрыВыполненияЭтапа = Справочники.TBM_ОбщенияБотовTelegramСЧатами.НоваяСтруктураПараметровВыполненияЭтапа();
		ПараметрыВыполненияЭтапа.НаименованиеТекущегоЭтапа = НаименованиеСтартовогоЭтапа;
		ПараметрыВыполненияЭтапа.ИдентификаторТекущегоЭтапа = ИдентификаторСтартовогоЭтапа;
		ПараметрыВыполненияЭтапа.ИдентификаторСообщения = ВыборкаЧаты.ИдентификаторСообщения;
		ПараметрыВыполненияЭтапа.ТекстСообщения = ВыборкаЧаты.ТекстСообщения;
		ПараметрыВыполненияЭтапа.Контакт.Имя = ВыборкаЧаты.ИмяКонтакта;
		ПараметрыВыполненияЭтапа.Контакт.НомерТелефона = ВыборкаЧаты.НомерТелефонаКонтакта;
		ПараметрыВыполненияЭтапа.ПроизвольныйКод = ПроизвольныйКодСтартовогоЭтапа;

		ВыборкаКнопкиКлавиатуры = ВыборкаСценарии.КнопкиКлавиатуры.Выбрать();
		Пока ВыборкаКнопкиКлавиатуры.Следующий() Цикл
			Если ВыборкаКнопкиКлавиатуры.УникальныйИдентификатор = ИдентификаторСтартовогоЭтапа Тогда
				КнопкаКлавиатуры = Справочники.TBM_ОбщенияБотовTelegramСЧатами.НоваяСтруктураКнопкаКлавиатуры();
				ЗаполнитьЗначенияСвойств(КнопкаКлавиатуры, ВыборкаКнопкиКлавиатуры);
				ПараметрыВыполненияЭтапа.КнопкиКлавиатуры.Добавить(КнопкаКлавиатуры);
			КонецЕсли;
		КонецЦикла;

		ВыполнитьЭтапОбщения(ОбщениеОбъект.Ссылка, ПараметрыВыполненияЭтапа);

	КонецЦикла;

КонецПроцедуры

Процедура ПродолжитьОбщениеСЧатом(ДанныеЧата, ДанныеОбщения)

	ПараметрыВыполненияЭтапа = Справочники.TBM_ОбщенияБотовTelegramСЧатами.НоваяСтруктураПараметровВыполненияЭтапа();
	ПараметрыВыполненияЭтапа.НаименованиеТекущегоЭтапа = ДанныеОбщения.НаименованиеЭтапа;
	ПараметрыВыполненияЭтапа.ИдентификаторТекущегоЭтапа = ДанныеОбщения.УникальныйИдентификатор;
	ПараметрыВыполненияЭтапа.ИдентификаторСообщения = ДанныеЧата.ИдентификаторСообщения;
	ПараметрыВыполненияЭтапа.ТекстСообщения = ДанныеЧата.ТекстСообщения;
	ПараметрыВыполненияЭтапа.Контакт.Имя = ДанныеЧата.ИмяКонтакта;
	ПараметрыВыполненияЭтапа.Контакт.НомерТелефона = ДанныеЧата.НомерТелефонаКонтакта;
	ПараметрыВыполненияЭтапа.ПроизвольныйКод = ДанныеОбщения.ПроизвольныйКод;

	Сценарий = ДанныеОбщения.Сценарий; // СправочникСсылка.TBM_СценарииБотовTelegram
	ВыборкаКнопкиКлавиатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сценарий, "КнопкиКлавиатуры").Выбрать();
	Пока ВыборкаКнопкиКлавиатуры.Следующий() Цикл
		Если ВыборкаКнопкиКлавиатуры.УникальныйИдентификатор = ДанныеОбщения.УникальныйИдентификатор Тогда
			КнопкаКлавиатуры = Справочники.TBM_ОбщенияБотовTelegramСЧатами.НоваяСтруктураКнопкаКлавиатуры();
			ЗаполнитьЗначенияСвойств(КнопкаКлавиатуры, ВыборкаКнопкиКлавиатуры);
			ПараметрыВыполненияЭтапа.КнопкиКлавиатуры.Добавить(КнопкаКлавиатуры);
		КонецЕсли;
	КонецЦикла;

	ВыполнитьЭтапОбщения(ДанныеОбщения.Общение, ПараметрыВыполненияЭтапа);

КонецПроцедуры

Процедура ВыполнитьЭтапОбщения(Общение, ПараметрыВыполненияЭтапа)

	ОбщениеОбъект = Общение.ПолучитьОбъект();

	Бот = ОбщениеОбъект.Бот;
	ИдентификаторЧата = ОбщениеОбъект.ИдентификаторЧата;

	НачатьТранзакцию();

	Попытка

		Результат = ОбщениеОбъект.ВыполнитьЭтап(ПараметрыВыполненияЭтапа);

		ОбщениеОбъект.Записать();

		Если ЗначениеЗаполнено(Результат.Ответ) Тогда

			Сообщение = НоваяСтруктураСообщенияЧата();
			Сообщение.chat_id = ИдентификаторЧата;
			Сообщение.text = Результат.Ответ;

			Клавиатура = СтруктураУдаленияКлавиатуры();

			КнопкиКлавиатуры = Новый Массив;
			Для Каждого Кнопка Из ПараметрыВыполненияЭтапа.КнопкиКлавиатуры Цикл
				КнопкаКлавиатуры = НоваяКнопкаКлавиатуры();
				КнопкаКлавиатуры.text = Кнопка.Наименование;
				КнопкаКлавиатуры.request_contact = Кнопка.ЗапросНомераТелефона;
				КнопкиКлавиатуры.Добавить(КнопкаКлавиатуры);
			КонецЦикла;

			Если КнопкиКлавиатуры.Количество() > 0 Тогда
				Клавиатура = НоваяКлавиатураПредоределенногоОтвета();
				Клавиатура.keyboard.Добавить(КнопкиКлавиатуры);
			КонецЕсли;

			Сообщение.reply_markup = Клавиатура;

			ОтправитьСообщениеВЧат(Бот, Сообщение);

		КонецЕсли;

		Для Каждого ДвоичныеДанные Из Результат.Документы Цикл
			ОтправитьДокументВЧат(Бот, ДвоичныеДанные);
		КонецЦикла;

		ЗафиксироватьТранзакцию();

	Исключение

		ОтменитьТранзакцию();

		ИмяСобытия = ИмяСобытияВзаимодействияСБотамиTelegram();

		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);

		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, Бот.Метаданные(), Бот, СтрШаблон(НСтр(
			"en = 'Error: %1'; ru = 'Ошибка: %1'; az = 'Səhv: %1'"), ПодробноеПредставлениеОшибки));

		ОтправитьСообщениеОбОшибке(Бот, ИдентификаторЧата);

	КонецПопытки;

	ДанныеСообщения = Новый Структура;
	ДанныеСообщения.Вставить("ИдентификаторСообщения", ПараметрыВыполненияЭтапа.ИдентификаторСообщения);
	ДанныеСообщения.Вставить("ТекстСообщения", ПараметрыВыполненияЭтапа.ТекстСообщения);

	СохранитьОбработанноеСообщение(Бот, ОбщениеОбъект.Чат, ДанныеСообщения);

КонецПроцедуры

Процедура ЗавершитьНеоконченноеОбщениеСЧатом(Общение)

	ОбщениеОбъект = Общение.ПолучитьОбъект();
	ОбщениеОбъект.Завершено = Истина;
	ОбщениеОбъект.Записать();

КонецПроцедуры

#КонецОбласти

#Область ВыполнениеПроизвольногоСценария

Процедура ВыполнитьСценарийИОтправитьСообщениеВЧат(Бот, ВыборкаСценарии)

	ВыборкаЧатов = ВыборкаСценарии.Выбрать();

	Сценарий = ВыборкаСценарии.Сценарий; // СправочникСсылка.TBM_СценарииБотовTelegram
	ПроизвольныйКод = ВыборкаСценарии.ПроизвольныйКод; // Строка

	НовыеЧаты = Новый Соответствие;

	Пока ВыборкаЧатов.Следующий() Цикл

		ИдентификаторЧата = ВыборкаЧатов.ИдентификаторЧата;

		Чат = ВыборкаЧатов.Чат;
		Если Не ЗначениеЗаполнено(Чат) Тогда
			Чат = НовыеЧаты[ИдентификаторЧата];
		КонецЕсли;

		Если Чат = Неопределено Тогда
			Чат = СоздатьНовыйЧатБота(Бот, ВыборкаЧатов);
			НовыеЧаты.Вставить(ИдентификаторЧата, Чат);
		КонецЕсли;

		ПараметрыВычисления = Новый Структура;
		ПараметрыВычисления.Вставить("Бот", Бот);
		ПараметрыВычисления.Вставить("Сценарий", Сценарий);
		ПараметрыВычисления.Вставить("Чат", Чат);
		ПараметрыВычисления.Вставить("ИдентификаторЧата", ИдентификаторЧата);

		Результат = НоваяСтруктураРезультатаПроизвольногоКода();
		ВыполнитьПроизвольныйКод(ПроизвольныйКод, ПараметрыВычисления, Результат);

		СообщениеОтправлено = Ложь;

		Если ЗначениеЗаполнено(Результат.ТекстСообщения) Тогда
			Сообщение = НоваяСтруктураСообщенияЧата();
			Сообщение.chat_id = ИдентификаторЧата;
			Сообщение.text = Результат.ТекстСообщения;
			Если ОтправитьСообщениеВЧат(Бот, Сообщение) Тогда
				СообщениеОтправлено = Истина;
			КонецЕсли;
		КонецЕсли;

		Если ЗначениеЗаполнено(Результат.ДвоичныеДанныеДокумента) Тогда
			ДвоичныеДанныеСообщения = ТелоВыгрузкиДокумента(ИдентификаторЧата, Результат.ДвоичныеДанныеДокумента);
			Если ОтправитьДокументВЧат(Бот, ДвоичныеДанныеСообщения) Тогда
				СообщениеОтправлено = Истина;
			КонецЕсли;
		КонецЕсли;

		Если СообщениеОтправлено Тогда
			СохранитьОбработанноеСообщение(Бот, Чат, ВыборкаЧатов);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ВыполнитьПроизвольныйКод(ПроизвольныйКод, Параметры, Результат = Неопределено)

	Попытка

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

	Исключение

		ИмяСобытия = ИмяСобытияВзаимодействияСБотамиTelegram();

		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);

		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, Параметры.Бот.Метаданные(), Параметры.Бот,
			СтрШаблон(НСтр("en = 'Error: %1'; ru = 'Ошибка: %1'; az = 'Səhv: %1'"), ПодробноеПредставлениеОшибки));

	КонецПопытки;

КонецПроцедуры

Функция НоваяСтруктураРезультатаПроизвольногоКода() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("ДвоичныеДанныеДокумента", Неопределено);

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ОтправкаДокумента

Функция ТелоВыгрузкиДокумента(ИдентификаторЧата, ДвоичныеДанные)

	Разделитель = РазделительMultipartFormData();

	ПотокВпамяти = Новый ПотокВПамяти;

	ЗаписьДанных = Новый ЗаписьДанных(ПотокВпамяти, , , Символы.ВК + Символы.ПС, "");
	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
	ЗаписьДанных.ЗаписатьСтроку("Content-Disposition: form-data; name=""document""; filename=""document.pdf""");
	ЗаписьДанных.ЗаписатьСтроку("Content-Type: multipart/form-data");
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.Записать(ДвоичныеДанные);
	ЗаписьДанных.ЗаписатьСтроку("");

	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель);
	ЗаписьДанных.ЗаписатьСтроку("Content-Disposition: form-data; name=""chat_id""");
	ЗаписьДанных.ЗаписатьСтроку("");
	ЗаписьДанных.ЗаписатьСтроку(ИдентификаторЧата);
	ЗаписьДанных.ЗаписатьСтроку("");

	ЗаписьДанных.ЗаписатьСтроку("--" + Разделитель + "--");

	ЗаписьДанных.Закрыть();

	Возврат ПотокВпамяти.ЗакрытьИПолучитьДвоичныеДанные();

КонецФункции

Функция РазделительMultipartFormData()

	Возврат "WebKitFormBoundary7MA4YWxkTrZu0gW";

КонецФункции

#КонецОбласти

#Область Прочее

Функция СоздатьНовыйЧатБота(Бот, ДанныеЧата)

	ЧатОбъект = Справочники.TBM_ЧатыTelegram.СоздатьЭлемент();
	ЧатОбъект.Владелец = Бот;
	ЧатОбъект.Код = ДанныеЧата.ИдентификаторЧата;
	ЧатОбъект.Записать();

	Возврат ЧатОбъект.Ссылка;

КонецФункции

Процедура СохранитьОбработанноеСообщение(Бот, Чат, ДанныеСообщения)

	НоваяЗапись = РегистрыСведений.TBM_ОбработанныеСообщенияБотовTelegram.СоздатьМенеджерЗаписи();
	НоваяЗапись.ИдентификаторСообщения = ДанныеСообщения.ИдентификаторСообщения;
	НоваяЗапись.Бот = Бот;
	НоваяЗапись.Чат = Чат;
	НоваяЗапись.Дата = ТекущаяДатаСеанса();
	НоваяЗапись.ТекстСообщения = ДанныеСообщения.ТекстСообщения;
	НоваяЗапись.Записать();

КонецПроцедуры

Функция ИмяСобытияВзаимодействияСБотамиTelegram()

	Возврат НСтр("en = 'Telegram bots'; ru = 'Боты Telegram'; az = 'Telegram botları'",
		ОбщегоНазначения.КодОсновногоЯзыка());

КонецФункции

Функция НайтиБотаTelegramПоИмени(ИмяБота)

	Запрос = Новый Запрос("ВЫБРАТЬ
						  |	TBM_БотыTelegram.Ссылка КАК Бот
						  |ИЗ
						  |	Справочник.TBM_БотыTelegram КАК TBM_БотыTelegram
						  |ГДЕ
						  |	TBM_БотыTelegram.ВариантВзаимодействия = ЗНАЧЕНИЕ(Перечисление.TBM_ВариантыВзаимодействияСБотамиTelegram.РегламентноеЗадание)
						  |	И TBM_БотыTelegram.Код = &ИмяБота
						  |	И НЕ TBM_БотыTelegram.ПометкаУдаления");
	Запрос.УстановитьПараметр("ИмяБота", ИмяБота);

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Бот;
	КонецЕсли;

	Возврат Справочники.TBM_БотыTelegram.ПустаяСсылка();

КонецФункции

Процедура ОтправитьСообщениеОбОшибке(Бот, ИдентификаторЧата)

	Сообщение = НоваяСтруктураСообщенияЧата();
	Сообщение.chat_id = ИдентификаторЧата;
	Сообщение.text = НСтр(
		"az = 'Mesajın emal zaman səhv oldu.';en = 'An error occurred while processing the message.';ru = 'Произошла ошибка при обработке сообщения.'");
	ОтправитьСообщениеВЧат(Бот, Сообщение);

КонецПроцедуры

Процедура СообщитьОНеизвестнойКоманде(Бот, Чат, ВыборкаЧатов)

	Сообщение = НоваяСтруктураСообщенияЧата();
	Сообщение.chat_id = ВыборкаЧатов.ИдентификаторЧата;
	Сообщение.text = НСтр(
		"az = 'Zəhmət olmasa, mövcud bot əməliyyətdən birini seçin.';en = 'Please select one of the available bot commands.';ru = 'Пожалуйста, выберите одну из доступных команд бота.'");
	ОтправитьСообщениеВЧат(Бот, Сообщение);

	СохранитьОбработанноеСообщение(Бот, Чат, ВыборкаЧатов);

КонецПроцедуры

#КонецОбласти

#КонецОбласти