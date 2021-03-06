
Функция ПолучитьДанныеИнформационнойБазыДляСписка(Контроллер, ИмяОбъекта, МодельДанных, ТолькоСтруктура) Экспорт
	
	Перем СписокДанных;

	Если ТолькоСтруктура Тогда
		СписокДанных = Новый Массив;
	Иначе
		БазаИД = ОбщегоНазначения.ПолучитьЗначениеПараметраЗапроса(Контроллер, "db");
		Кластер = ОбщегоНазначения.ПолучитьКластерПоИД(Контроллер);
		ИнформационнаяБаза = ОбщегоНазначения.ПолучитьИнформационнуюБазуПоИд(Контроллер, БазаИД, Кластер);
		АвторизацияБазы = Новый АвторизацияИБ(Контроллер, Кластер, ИнформационнаяБаза);
		Если ИмяОбъекта = "session" Тогда
			СписокДанных = ОбщегоНазначения.ПолучитьСписокСеансовИБ(ИнформационнаяБаза);
		ИначеЕсли ИмяОбъекта = "connection" Тогда
			СписокДанных = ОбщегоНазначения.ПолучитьСписокСоединенийИБ(ИнформационнаяБаза);	
		КонецЕсли;
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("header", Новый Массив);
	Если Не ТолькоСтруктура Тогда
		Структура.Вставить("data", Новый Массив);
	КонецЕсли;
	
	Для Каждого Колонка Из МодельДанных.Колонки Цикл
		КолонкаДействий = Колонка = "Action"; 
		ИмяЗаголовка = ?(КолонкаДействий, "Действия", Колонка);
		Сортировка = Не КолонкаДействий;
		Колонка = Новый Структура("name, title, sortable", Колонка , ИмяЗаголовка, Сортировка);
		Структура.header.Добавить(Колонка);
	КонецЦикла;
	
	Если Не ТолькоСтруктура Тогда
		Для Каждого ЭлементДанных Из СписокДанных Цикл
			СтрокаДанных = Новый Массив;
			Для Каждого Колонка Из МодельДанных.Колонки Цикл
				Если Колонка = "Action" Тогда
					СтрокаДанных.Добавить(ПолучитьПредставлениеДействийСписка(
						МодельДанных.Действия, 
						ЭлементДанных.Получить(МодельДанных.ПолеИдентификатора)));	
					Продолжить;
				КонецЕсли;
				СтрокаДанных.Добавить(ЭлементДанных.Получить(Колонка));
			КонецЦикла;
			Структура.data.Добавить(СтрокаДанных);
		КонецЦикла;
	КонецЕсли;
	
	ПарсерJSON = Новый ПарсерJSON;
	ТелоЗапроса = ПарсерJSON.ЗаписатьJSON(Структура);	
	Возврат ТелоЗапроса;

КонецФункции

Функция ПолучитьПредставлениеДействийСписка(Действия, ПолеИдентификатора)

	Результат = "";

	ДополнитьВставкуHTML(Результат, "<div class=""toolbar"">");

	Для Каждого Действие Из Действия Цикл
		ДополнитьВставкуHTML(Результат, "<button class=""tool-button primary rounded list-action"" action=""" + Действие + """ data-id=""" + ПолеИдентификатора + """ onclick=""action_terminate(this);"">");
		ДополнитьВставкуHTML(Результат, "<i class=""fas fa-power-off""></i>");
		ДополнитьВставкуHTML(Результат, "</button>");
	КонецЦикла;

	ДополнитьВставкуHTML(Результат, "</div>");

	Возврат Результат;

КонецФункции

Процедура ДополнитьВставкуHTML(Результат, Значение)
	Результат = Результат + ?(ПустаяСтрока(Результат), "", Символы.ПС) + Значение;
КонецПроцедуры
