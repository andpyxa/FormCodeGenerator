&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ИнициализироватьПредварительныеНастройки();
//Элементы.ГруппаВыборФорм.ОтображатьЗаголовок .Отображение = отобажение
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПредварительныеНастройки()

	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");

	ПустоеДеревоЭлементов = ОбработкаОбъект.ДеревоЭлементов.Скопировать();
	ПустоеДеревоЭлементов.Строки.Очистить();
	ПустоеДеревоРеквизитов = ОбработкаОбъект.ДеревоРеквизитов.Скопировать();
	ПустоеДеревоРеквизитов.Строки.Очистить();
	ПустаяТаблицаКоманд = ОбработкаОбъект.ТаблицаКоманд.ВыгрузитьКолонки();

	ПараметрыРедакторФорм = Новый Структура;
	ПараметрыРедакторФорм.Вставить("СоответствиеТекстовыхПредставлений",
		ОбработкаОбъект.НовоеСоответствиеТекстовыхПредставлений());
	ПараметрыРедакторФорм.Вставить("СоответствиеПредставленийТипов",
		ОбработкаОбъект.НовоеСоответствиеПредставленийТипов());
	ПараметрыРедакторФорм.Вставить("ДеревоЭлементов", ПустоеДеревоЭлементов);
	ПараметрыРедакторФорм.Вставить("ДеревоРеквизитов", ПустоеДеревоРеквизитов);
	ПараметрыРедакторФорм.Вставить("ТаблицаКоманд", ПустаяТаблицаКоманд);

	Объект.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыРедакторФорм,
		ЭтаФорма.УникальныйИдентификатор);
	Объект.ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Объект.ИмяПодключеннойОбработки = ОбработкаОбъект.ИспользуемоеИмяФайла;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "SRVR=") Тогда
		//Положить обработку в хранилище и подключить
		Объект.АдресДанныхФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(
			Новый ДвоичныеДанные(Объект.ИмяПодключеннойОбработки), ЭтаФорма.УникальныйИдентификатор);
		ПодключитьОбработкуНаСервере();
	КонецЕсли;
	
	ОбновитьЗаголовокГиперссылок();
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеречитатьФорму(Команда)

	Если ЗначениеЗаполнено(ФормаАнализируемая) Тогда
		ИнициализироватьПредварительныеНастройки();
		ПодготовитьДанныеИзФормы(ФормаАнализируемая);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыКоманд

&НаКлиенте
Процедура ОбъектТаблицаКомандВыбранПриИзменении(Элемент)

	Объект.ТекстДобавленияКоманд = "";
	ШаблонКомандыПрограммно = "%1
							   |%2";
							   
							   
	КонтекстСформирован = Ложь;
	ВПредыдущемЭлементеБылиУстановленыСвойства = Ложь;
	
	Для Каждого Строка Из Объект.ТаблицаКоманд Цикл
		Если Строка.Выбран Тогда
			
			ТекстТекущейСтроки = "";
			
			Если Не КонтекстСформирован Или ВПредыдущемЭлементеБылиУстановленыСвойства Тогда
				КонтекстСформирован = Истина;
				ДобавитьТекст(ТекстТекущейСтроки, Строка.ТекстСозданиеКонтекста);
			КонецЕсли;
			
			Если Не ПустаяСтрока(Строка.ТекстЗаполненияСвойств) Тогда
				ВПредыдущемЭлементеБылиУстановленыСвойства = Истина;
				ДобавитьТекст(ТекстТекущейСтроки, Строка.ТекстЗаполненияСвойств);
			Иначе
				ВПредыдущемЭлементеБылиУстановленыСвойства = Ложь;				
			КонецЕсли;
			
			ДобавитьТекст(ТекстТекущейСтроки, Строка.ТекстСоздания);
			
			ДобавитьТекст(Объект.ТекстДобавленияКоманд, ТекстТекущейСтроки);
		КонецЕсли;	
	КонецЦикла; 
						   
	ОбновитьОбщийТекстПрограмногоДобаления();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьТекст(ИсходныйТекст, НовыйТекст)
	
	Если ПустаяСтрока(НовыйТекст) Тогда
		Возврат;
	КонецЕсли;
	
	ИсходныйТекст = ИсходныйТекст + ?(ПустаяСтрока(ИсходныйТекст),"", Символы.ПС) + НовыйТекст;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовДереваЭлементов

&НаКлиенте
Процедура ОбъектДеревоЭлементовВыбранПриИзменении(Элемент)

	ИдентификаторыВыбранныхЭлементов = Новый Массив;
	ДополнитьИдентификаторыНайденнымиВнутри(ИдентификаторыВыбранныхЭлементов, Объект.ДеревоЭлементов);

	Объект.ТекстДобавленияЭлементов = "";

	ШаблонЭлементыПрограммно = "%1
							   |%2";

	ТекстЭлементыПрограммно = ШаблонЭлементыПрограммно;

	Если ИдентификаторыВыбранныхЭлементов.Количество() > 0 Тогда

		Для Каждого Идентификатор Из ИдентификаторыВыбранныхЭлементов Цикл
			ЭлементРеквизита = Объект.ДеревоЭлементов.НайтиПоИдентификатору(Идентификатор);
				
				//ШаблонРеквизита = ШаблонЭлементыПрограммно + Символы.ПС;
				//ТекстДобавления = СтрШаблон(ШаблонРеквизита, ЭлементРеквизита.ТекстСоздания, ТекстДобавитьВМассив);
				//ТекстРеквизитыПрограммно = СтрШаблон(ТекстРеквизитыПрограммно, ТекстДобавления, ШаблонЭлементыПрограммно);

			Объект.ТекстДобавленияЭлементов = Объект.ТекстДобавленияЭлементов + Символы.ПС + ЭлементРеквизита.ТекстНачало
				+ Символы.ПС + ЭлементРеквизита.ТекстУстановкиСвойств + Символы.ПС + ЭлементРеквизита.ТекстСоздания;

			Объект.ТекстДобавленияЭлементов = Объект.ТекстДобавленияЭлементов + Символы.ПС;
		КонецЦикла;
	КонецЕсли;

	ОбновитьОбщийТекстПрограмногоДобаления();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовДереваРеквизитов

&НаКлиенте
Процедура ОбъектДеревоРеквизитовВыбранПриИзменении(Элемент)

	ИдентификаторыВыбранныхРеквизитов = Новый Массив;
	ДополнитьИдентификаторыНайденнымиВнутри(ИдентификаторыВыбранныхРеквизитов, Объект.ДеревоРеквизитов);

	Объект.ТекстДобавленияРеквизитов = "";
	ТекстИнициализироватьМассив = "НовыеРеквизитыФормы = Новый Массив;" + Символы.ПС + Символы.ПС;
	ТекстИзменитьРеквизитыФормы = "Форма.ИзменитьРеквизиты(НовыеРеквизитыФормы);";
	ТекстДобавитьВМассив = "НовыеРеквизитыФормы.Добавить(НовыйРеквизит);";
	ШаблонРеквизитыПрограммно = "%1
								|%2";
	ТекстРеквизитыПрограммно = ШаблонРеквизитыПрограммно;

	Если ИдентификаторыВыбранныхРеквизитов.Количество() > 0 Тогда
		Для Каждого Идентификатор Из ИдентификаторыВыбранныхРеквизитов Цикл
			ЭлементРеквизита = Объект.ДеревоРеквизитов.НайтиПоИдентификатору(Идентификатор);

			ШаблонРеквизита = ШаблонРеквизитыПрограммно + Символы.ПС;
			ТекстДобавления = СтрШаблон(ШаблонРеквизита, ЭлементРеквизита.ТекстСоздания, ТекстДобавитьВМассив);
			ТекстРеквизитыПрограммно = СтрШаблон(ТекстРеквизитыПрограммно, ТекстДобавления, ШаблонРеквизитыПрограммно);
		КонецЦикла;

		Объект.ТекстДобавленияРеквизитов = ТекстИнициализироватьМассив + СтрШаблон(ТекстРеквизитыПрограммно,
			ТекстИзменитьРеквизитыФормы, "");

	КонецЕсли;

	ОбновитьОбщийТекстПрограмногоДобаления();

КонецПроцедуры
&НаКлиенте
Процедура ОбновитьОбщийТекстПрограмногоДобаления()
	Объект.ТекстПрограммногоДобавления = Объект.ТекстДобавленияРеквизитов + Объект.ТекстДобавленияКоманд + Объект.ТекстДобавленияЭлементов;
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьИдентификаторыНайденнымиВнутри(ИдентификаторыВыбранных, ТекущийЭлемент)

	Для Каждого Строка Из ТекущийЭлемент.ПолучитьЭлементы() Цикл

		Если Строка.Выбран Тогда
			ИдентификаторыВыбранных.Добавить(Строка.ПолучитьИдентификатор());
		КонецЕсли;

		ДополнитьИдентификаторыНайденнымиВнутри(ИдентификаторыВыбранных, Строка);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ФормаАнализируемаяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборФормыАнализируемойЗавершение", ЭтотОбъект);

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФормаИмяОбъекта", ФормаИмяОбъекта);
	ПараметрыОткрытия.Вставить("ФормаТипОбъекта", ФормаТипОбъекта);
	ПараметрыОткрытия.Вставить("ФормаИмяФормы", ФормаИмяФормы);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", ФормаАнализируемая);

	ОткрытьФорму("ВнешняяОбработка.FormGenerator.Форма.ФормаВыбораФормы", ПараметрыОткрытия, Элемент, , , ,
		ОповещениеВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ВыборФормыАнализируемойЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если Параметры.Эталонная = Ложь Тогда
	
			ФормаАнализируемая = Результат.ПолныйПутьКФорме;
			ФормаТипОбъекта = Результат.ТипОбъекта;
			ФормаИмяОбъекта = Результат.ИмяОбъекта;
			ФормаИмяФормы = Результат.ИмяФормы;
	
			ПодготовитьДанныеИзФормы(ФормаАнализируемая);
		Иначе
			ФормаЭталонная = Результат.ПолныйПутьКФорме;
			ПодготовитьДанныеИзФормы(ФормаЭталонная);
		КонецЕсли;	
	КонецЕсли;
		
	ОбновитьЗаголовокГиперссылок();
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодготовитьДанныеИзФормы(ПолныйПутьКФорме)

	ПараметрыПолученияДанных = Новый Структура;
	ПараметрыПолученияДанных.Вставить("АдресВоВременномХранилище", Объект.АдресВоВременномХранилище);
	ПараметрыПолученияДанных.Вставить("ИмяПодключеннойОбработки", Объект.ИмяПодключеннойОбработки);
	ПараметрыПолученияДанных.Вставить("ИмяВременногоФайла", Объект.ИмяВременногоФайла);

	ПараметрыФормы = Новый Структура("РедакторФорм", ПараметрыПолученияДанных);

	Объект.ПолныйПутьКФорме = ПолныйПутьКФорме;
	ПолучитьФорму(ПолныйПутьКФорме, ПараметрыФормы);

	ЗаполнитьДанныеПоХранилищу();

КонецПроцедуры
&НаСервере
Процедура ЗаполнитьДанныеПоХранилищу() Экспорт

	ФайлСДанными = Новый Файл(Объект.ИмяВременногоФайла);

	Если ФайлСДанными.Существует() Тогда
		ПараметрыРедакторФорм = ЗначениеИзФайла(Объект.ИмяВременногоФайла);
		УдалитьФайлы(Объект.ИмяВременногоФайла);
		ЗначениеВРеквизитФормы(ПараметрыРедакторФорм.ДеревоРеквизитов, "Объект.ДеревоРеквизитов");
		ЗначениеВРеквизитФормы(ПараметрыРедакторФорм.ДеревоЭлементов, "Объект.ДеревоЭлементов");
		Объект.ТаблицаКоманд.Загрузить(ПараметрыРедакторФорм.ТаблицаКоманд);

	Иначе
		Сообщить("Заполнение не выполнено!
				 |Необходимо разместить в процедуре ""ПриСозданииНаСервере()""
				 |модуля формы """ + Объект.ПолныйПутьКФорме + """ следующий код:
															   |
															   |Если ЭтаФорма.Параметры.Свойство(""РедакторФорм"") Тогда
															   |     ВнешниеОбработки.Создать(ЭтаФорма.Параметры.РедакторФорм.ИмяПодключеннойОбработки,Ложь).ПодготовитьДанныеАнализируемойФормы(ЭтаФорма);
															   |КонецЕсли;"); 
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуДляАнализа(Команда)
	
	Параметр = Новый Структура("Эталонная", Ложь);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборФормыАнализируемойЗавершение", ЭтотОбъект, Параметр);

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФормаИмяОбъекта", ФормаИмяОбъекта);
	ПараметрыОткрытия.Вставить("ФормаТипОбъекта", ФормаТипОбъекта);
	ПараметрыОткрытия.Вставить("ФормаИмяФормы", ФормаИмяФормы);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", ФормаАнализируемая);

	ОткрытьФорму("ВнешняяОбработка.FormGenerator.Форма.ФормаВыбораФормы", ПараметрыОткрытия, , , , ,
		ОповещениеВыбора);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЭталоннуюФормуДляАнализа(Команда)
	
	Параметр = Новый Структура("Эталонная", Истина);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборФормыАнализируемойЗавершение", ЭтотОбъект, Параметр);

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФормаИмяОбъекта", ФормаИмяОбъекта);
	ПараметрыОткрытия.Вставить("ФормаТипОбъекта", ФормаТипОбъекта);
	ПараметрыОткрытия.Вставить("ФормаИмяФормы", ФормаИмяФормы);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", ФормаАнализируемая);

	ОткрытьФорму("ВнешняяОбработка.FormGenerator.Форма.ФормаВыбораФормы", ПараметрыОткрытия, , , , ,
		ОповещениеВыбора);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокГиперссылок()
	
	Если ПустаяСтрока(ФормаАнализируемая) Тогда
		Элементы.ВыбратьФормуДляАнализа.Заголовок = НСтр("ru = 'Выбрать форму для анализа'");
	Иначе
		Шаблон = НСтр("ru = 'Форма: %1'"); 
		Элементы.ВыбратьФормуДляАнализа.Заголовок = СтрШаблон(Шаблон, ФормаАнализируемая);
	КонецЕсли;

	Если ПустаяСтрока(ФормаЭталонная) Тогда
		Элементы.ВыбратьЭталоннуюФормуДляАнализа.Заголовок = НСтр("ru = 'Выбрать эталонную форму для анализа'");
	Иначе
		Шаблон = НСтр("ru = 'Эталонная : %1'"); 
		Элементы.ВыбратьЭталоннуюФормуДляАнализа.Заголовок = СтрШаблон(Шаблон, ФормаЭталонная);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПодключитьОбработкуНаСервере()
	Объект.ИмяПодключеннойОбработки = ВнешниеОбработки.Подключить(Объект.АдресДанныхФайлаВоВременномХранилище, , Ложь);
КонецПроцедуры
#КонецОбласти