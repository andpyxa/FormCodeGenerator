#Область ОписаниеПеременных

&НаКлиенте
Перем ИмяРедактируемогоРеквизита;

#КонецОбласти

&НаКлиенте
Функция ПолучитьРеквизитыФормы() Экспорт

	Результат = ПолучитьРеквизитыНаСервере();

	Возврат Результат;
КонецФункции

&НаСервере
Функция ПолучитьРеквизитыНаСервере()

	Реквизиты = ЭтаФорма.ПолучитьРеквизиты();
	
	СтруктураРеквизитовФормы = Новый Структура;
	Для Каждого Эл Из Реквизиты Цикл
		Структура = Новый Структура;
		Структура.Вставить("Заголовок", Эл.Заголовок);
		Структура.Вставить("Имя", Эл.Имя);
		Структура.Вставить("Путь", Эл.Путь);
		Структура.Вставить("ТипЗначения", ОбщегоНазначения.СтроковоеПредставлениеТипа(Эл.ТипЗначения.Типы()[0]));
		СтруктураРеквизитовФормы.Вставить(Эл.Имя, Структура);
	КонецЦикла;
	
	СтруктураПутей = Новый Структура;
	
	Для Каждого эл из ЭтаФорма.Элементы Цикл 
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(эл, "ПутьКДанным") Тогда
			Если ЗначениеЗаполнено(эл.ПутьКДанным) Тогда
				СтруктураПутей.Вставить(эл.Имя, эл.ПутьКДанным);	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый Структура("РеквизитыФормы, ЭлементыПутьКДанным", СтруктураРеквизитовФормы, СтруктураПутей);
КонецФункции

// ПолучитьРеквизиты()

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		БИКБанка		  = Объект.БИКБанка;
		НаименованиеБанка = Объект.НаименованиеБанка;
		КоррСчетБанка	  = Объект.КоррСчетБанка;
		ГородБанка		  = Объект.ГородБанка;
		СВИФТБИК = Объект.СВИФТБИК;
 	Иначе
		Если НЕ Объект.Банк.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
		КонецЕсли;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если (ЗначениеЗаполнено(Объект.БИКБанкаДляРасчетов)) Или (ЗначениеЗаполнено(Объект.БанкДляРасчетов)) 
			Или ЗначениеЗаполнено(Объект.СВИФТБИКДляРасчетов) Тогда
			ИспользуетсяБанкДляРасчетов = Истина;
		Иначе
			ИспользуетсяБанкДляРасчетов = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
		БИКБанкаДляРасчетов			 = Объект.БИКБанкаДляРасчетов;
		НаименованиеБанкаДляРасчетов = Объект.НаименованиеБанкаДляРасчетов;
		КоррСчетБанкаДляРасчетов	 = Объект.КоррСчетБанкаДляРасчетов;
		ГородБанкаДляРасчетов		 = Объект.ГородБанкаДляРасчетов;
		СВИФТБИКДляРасчетов = Объект.СВИФТБИКДляРасчетов;
 	Иначе
		Если НЕ Объект.БанкДляРасчетов.Пустая() Тогда
			ЗаполнитьРеквизитыБанкаПоБанку(Объект.БанкДляРасчетов, "БанкДляРасчетов", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	НациональнаяВалюта = Справочники.Валюты.НайтиПоКоду("643");
	СпособУказанияРеквизитовБанка = ?(Объект.РучноеИзменениеРеквизитовБанка, "Вручную", "ИзКлассификатора");
	СпособУказанияРеквизитовБанкаРасчетов = ?(Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов, "Вручную", "ИзКлассификатора");
	МестоОткрытия = ?(Объект.Зарубежный, "ЗаРубежом", "РФ");
	
	ОбновитьТекстПоясненияНедействительностиБанка();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)

	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник._ДемоБанковскиеСчета.Форма.РеквизитыБанка") Тогда
		Если Не ПустаяСтрока(РезультатВыбора) Тогда
			Если РезультатВыбора.Реквизит = "БИКБанка" Тогда
				Объект.РучноеИзменениеРеквизитовБанка = РезультатВыбора.РучноеИзменение;
				Если РезультатВыбора.РучноеИзменение Тогда
					Объект.Банк				 = "";
					Объект.БИКБанка			 = РезультатВыбора.ЗначенияПолей.БИК;
					Объект.НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
					Объект.КоррСчетБанка	 = РезультатВыбора.ЗначенияПолей.КоррСчет;
					Объект.ГородБанка		 = РезультатВыбора.ЗначенияПолей.Город;
					Объект.АдресБанка		 = РезультатВыбора.ЗначенияПолей.Адрес;
					Объект.ТелефоныБанка	 = РезультатВыбора.ЗначенияПолей.Телефоны;
					
					БИКБанка		  = РезультатВыбора.ЗначенияПолей.БИК;
					КоррСчетБанка	  = РезультатВыбора.ЗначенияПолей.КоррСчет;
					НаименованиеБанка = РезультатВыбора.ЗначенияПолей.Наименование;
					ГородБанка		  = РезультатВыбора.ЗначенияПолей.Город;
				Иначе
					Объект.Банк				 = РезультатВыбора.Банк;
					Объект.БИКБанка			 = "";
					Объект.НаименованиеБанка = "";
					Объект.КоррСчетБанка	 = "";
					Объект.ГородБанка		 = "";
					Объект.АдресБанка		 = "";
					Объект.ТелефоныБанка	 = "";
					
                    ЗаполнитьРеквизитыБанкаПоБанку(Объект.Банк, "Банк", Ложь);
				КонецЕсли;
			ИначеЕсли РезультатВыбора.Реквизит = "БИКБанкаДляРасчетов" Тогда
				Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = РезультатВыбора.РучноеИзменение;
				Если РезультатВыбора.РучноеИзменение Тогда
					Объект.БанкДляРасчетов				= "";
					Объект.БИКБанкаДляРасчетов			= РезультатВыбора.ЗначенияПолей.БИК;
					Объект.НаименованиеБанкаДляРасчетов = РезультатВыбора.ЗначенияПолей.Наименование;
					Объект.КоррСчетБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.КоррСчет;
					Объект.ГородБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Город;
					Объект.АдресБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Адрес;
					Объект.ТелефоныБанкаДляРасчетов		= РезультатВыбора.ЗначенияПолей.Телефоны;
					
					БИКБанкаДляРасчетов			 = РезультатВыбора.ЗначенияПолей.БИК; 
					КоррСчетБанкаДляРасчетов	 = РезультатВыбора.ЗначенияПолей.КоррСчет;
					НаименованиеБанкаДляРасчетов = РезультатВыбора.ЗначенияПолей.Наименование;
					ГородБанкаДляРасчетов		 = РезультатВыбора.ЗначенияПолей.Город;
				Иначе
					Объект.БанкДляРасчетов				= РезультатВыбора.Банк;
					Объект.БИКБанкаДляРасчетов			= "";
					Объект.НаименованиеБанкаДляРасчетов = "";
					Объект.КоррСчетБанкаДляРасчетов		= "";
					Объект.ГородБанкаДляРасчетов		= "";
					Объект.АдресБанкаДляРасчетов		= "";
					Объект.ТелефоныБанкаДляРасчетов		= "";
					
					ЗаполнитьРеквизитыБанкаПоБанку(Объект.БанкДляРасчетов, "БанкДляРасчетов", Ложь);	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.КлассификаторБанковРФ.Форма.ФормаВыбора") Тогда	
		Если ТипЗнч(РезультатВыбора) = Тип("СправочникСсылка.КлассификаторБанковРФ") Тогда
			Если ИмяРедактируемогоРеквизита = "БИКБанка" Тогда
				Объект.Банк				 = РезультатВыбора;
				Объект.БИКБанка			 = "";
				Объект.НаименованиеБанка = "";
				Объект.КоррСчетБанка	 = "";
				Объект.ГородБанка		 = "";
				Объект.АдресБанка		 = "";
				Объект.ТелефоныБанка	 = "";

				ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "Банк", Ложь);
			ИначеЕсли ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов" Тогда
				Объект.БанкДляРасчетов				= РезультатВыбора;
				Объект.БИКБанкаДляРасчетов			= "";
				Объект.НаименованиеБанкаДляРасчетов = "";
				Объект.КоррСчетБанкаДляРасчетов		= "";
				Объект.ГородБанкаДляРасчетов		= "";
				Объект.АдресБанкаДляРасчетов		= "";
				Объект.ТелефоныБанкаДляРасчетов		= "";

				ЗаполнитьРеквизитыБанкаПоБанку(РезультатВыбора, "БанкДляРасчетов", Ложь);
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
	ОбновитьТекстПоясненияНедействительностиБанка();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.РучноеИзменениеРеквизитовБанка Тогда
		Объект.БИКБанка			 = БИКБанка;
		Объект.КоррСчетБанка	 = КоррСчетБанка;
		Объект.НаименованиеБанка = НаименованиеБанка;
		Объект.ГородБанка		 = ГородБанка;
		Объект.СВИФТБИК = СВИФТБИК;
	Иначе
		Объект.БИКБанка			 = "";
		Объект.КоррСчетБанка	 = "";
		Объект.НаименованиеБанка = "";
		Объект.ГородБанка		 = "";
		Объект.СВИФТБИК = "";
	КонецЕсли;
	
	Если ИспользуетсяБанкДляРасчетов И Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
		Объект.БИКБанкаДляРасчетов			= БИКБанкаДляРасчетов;
		Объект.КоррСчетБанкаДляРасчетов		= КоррСчетБанкаДляРасчетов;
		Объект.НаименованиеБанкаДляРасчетов = НаименованиеБанкаДляРасчетов;
		Объект.ГородБанкаДляРасчетов		= ГородБанкаДляРасчетов;
		Объект.СВИФТБИКДляРасчетов = СВИФТБИКДляРасчетов;
	Иначе
		Объект.БИКБанкаДляРасчетов			= "";
		Объект.КоррСчетБанкаДляРасчетов		= "";
		Объект.НаименованиеБанкаДляРасчетов = "";
		Объект.ГородБанкаДляРасчетов		= "";
		Объект.СВИФТБИКДляРасчетов = "";
	КонецЕсли;	
	
	Объект.Зарубежный = МестоОткрытия = "ЗаРубежом";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользуетсяБанкДляРасчетовПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанка";
	РеквизитБанкаПриВыборе("БИКБанка", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаОткрытие(Элемент, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанка";
	СтандартнаяОбработка = Ложь;
	РеквизитБанкаОткрытие("БИКБанка");
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаДляРасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	РеквизитБанкаПриВыборе("БИКБанкаДляРасчетов", ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура БИКБанкаДляРасчетовОткрытие(Элемент, СтандартнаяОбработка)
	ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	СтандартнаяОбработка = Ложь;
	РеквизитБанкаОткрытие("БИКБанкаДляРасчетов");
КонецПроцедуры

&НаКлиенте
Процедура МестоОткрытияПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияРеквизитовБанкаРасчетовПриИзменении(Элемент)
	Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = СпособУказанияРеквизитовБанкаРасчетов = "Вручную";
	Если СпособУказанияРеквизитовБанкаРасчетов = "ИзКлассификатора" Тогда
		ЗаполнитьРеквизитыБанкаПоБИК(БИКБанкаДляРасчетов, "БанкДляРасчетов", Истина);
	КонецЕсли;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СпособУказанияРеквизитовБанкаПриИзменении(Элемент)
	Объект.РучноеИзменениеРеквизитовБанка = СпособУказанияРеквизитовБанка = "Вручную";
	Если СпособУказанияРеквизитовБанка = "ИзКлассификатора" Тогда
		ЗаполнитьРеквизитыБанкаПоБИК(БИКБанка, "Банк", Истина);
	КонецЕсли;
	УправлениеЭлементамиФормы(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБИК(БИК, ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)
	
	НашлиПоБИК	 = Ложь;
	ЗаписьОБанке = "";
	
	Если ТипБанка = "Банк" Тогда
		
		БИКБанка		  = "";
		КоррСчетБанка	  = "";
		НаименованиеБанка = "";
		ГородБанка		  = "";
		РаботаСБанками.ПолучитьДанныеКлассификатораРФ(БИК,,ЗаписьОБанке);
		Если НЕ ПустаяСтрока(ЗаписьОБанке) Тогда
			БИКБанка          = ЗаписьОБанке.Код;
			КоррСчетБанка     = ЗаписьОБанке.КоррСчет;
			НаименованиеБанка = ЗаписьОБанке.Наименование;
			ГородБанка        = ЗаписьОБанке.Город;
			НашлиПоБИК        = Истина;
			СВИФТБИК = ЗаписьОБанке.СВИФТБИК;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.БИКБанка          = "";
				Объект.НаименованиеБанка = "";
				Объект.КоррСчетБанка     = "";
				Объект.ГородБанка        = "";
				Объект.АдресБанка        = "";
				Объект.ТелефоныБанка     = "";
				Объект.Банк              = ЗаписьОБанке;
			КонецЕсли;
		КонецЕсли;
		ДеятельностьБанкаПрекращена = Не Объект.РучноеИзменениеРеквизитовБанка И ДеятельностьБанкаПрекращена(БИКБанка);
	ИначеЕсли ТипБанка = "БанкДляРасчетов" Тогда
		БИКБанкаДляРасчетов          = "";
		КоррСчетБанкаДляРасчетов     = "";
		НаименованиеБанкаДляРасчетов = "";
		ГородБанкаДляРасчетов        = "";
		РаботаСБанками.ПолучитьДанныеКлассификатораРФ(БИК,,ЗаписьОБанке);
	 	Если НЕ ПустаяСтрока(ЗаписьОБанке) Тогда
			БИКБанкаДляРасчетов          = ЗаписьОБанке.Код;
			КоррСчетБанкаДляРасчетов     = ЗаписьОБанке.КоррСчет;
			НаименованиеБанкаДляРасчетов = ЗаписьОБанке.Наименование;
			ГородБанкаДляРасчетов        = ЗаписьОБанке.Город;
			СВИФТБИКДляРасчетов = ЗаписьОБанке.СВИФТБИК;
			НашлиПоБИК                   = Истина;
			Если ПеренестиЗначенияРеквизитов Тогда
				Объект.БИКБанкаДляРасчетов          = "";
				Объект.НаименованиеБанкаДляРасчетов = "";
				Объект.КоррСчетБанкаДляРасчетов     = "";
				Объект.ГородБанкаДляРасчетов        = "";
				Объект.АдресБанкаДляРасчетов        = "";
				Объект.ТелефоныБанкаДляРасчетов     = "";
				Объект.БанкДляРасчетов              = ЗаписьОБанке;
			КонецЕсли;
		КонецЕсли;
		ДеятельностьБанкаНепрямыхРасчетовПрекращена = Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов И ДеятельностьБанкаПрекращена(БИКБанкаДляРасчетов);
	КонецЕсли;
	
	ОбновитьТекстПоясненияНедействительностиБанка();
	
	Возврат НашлиПоБИК;
КонецФункции

&НаСервере
Функция ЗаполнитьРеквизитыБанкаПоБанку(Банк, ТипБанка, ПеренестиЗначенияРеквизитов = Ложь)
	Если ТипБанка = "Банк" Тогда
		БИКБанка          = Банк.Код;
		КоррСчетБанка     = Банк.КоррСчет;
		НаименованиеБанка = Банк.Наименование;
		ГородБанка        = Банк.Город;
		СВИФТБИК = Банк.СВИФТБИК;
		Если ПеренестиЗначенияРеквизитов Тогда
			Объект.БИКБанка          = Банк.Код;
			Объект.НаименованиеБанка = Банк.Наименование;
			Объект.КоррСчетБанка     = Банк.КоррСчет;
			Объект.ГородБанка        = Банк.Город;
			Объект.АдресБанка        = Банк.Адрес;
			Объект.ТелефоныБанка     = Банк.Телефоны;
			Объект.Банк              = "";
			Объект.СВИФТБИК = Банк.СВИФТБИК;
		КонецЕсли;
		ДеятельностьБанкаПрекращена = Не Объект.РучноеИзменениеРеквизитовБанка И ДеятельностьБанкаПрекращена(БИКБанка);
	ИначеЕсли ТипБанка = "БанкДляРасчетов" Тогда
		БИКБанкаДляРасчетов			 = Банк.Код;
		КоррСчетБанкаДляРасчетов	 = Банк.КоррСчет;
		НаименованиеБанкаДляРасчетов = Банк.Наименование;
		ГородБанкаДляРасчетов		 = Банк.Город;
		СВИФТБИКДляРасчетов = Банк.СВИФТБИК;
		Если ПеренестиЗначенияРеквизитов Тогда
			Объект.БИКБанкаДляРасчетов          = Банк.Код;
			Объект.НаименованиеБанкаДляРасчетов = Банк.Наименование;
			Объект.КоррСчетБанкаДляРасчетов     = Банк.КоррСчет;
			Объект.ГородБанкаДляРасчетов        = Банк.Город;
			Объект.АдресБанкаДляРасчетов        = Банк.Адрес;
			Объект.ТелефоныБанкаДляРасчетов     = Банк.Телефоны;
			Объект.БанкДляРасчетов              = "";
			Объект.СВИФТБИКДляРасчетов = Банк.СВИФТБИКДляРасчетов;
		КонецЕсли;
		ДеятельностьБанкаНепрямыхРасчетовПрекращена = Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов И ДеятельностьБанкаПрекращена(БИКБанкаДляРасчетов);
	КонецЕсли;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	ЭтоСчетОрганизации = (ТипЗнч(Форма.Объект.Владелец) = Тип("СправочникСсылка._ДемоОрганизации"));
	
	Форма.Элементы.СтраницаНастройкаПечати.Видимость = ЭтоСчетОрганизации;
	Форма.Элементы.СведенияОСчете.ОтображениеСтраниц = ?(ЭтоСчетОрганизации, ОтображениеСтраницФормы.ЗакладкиСверху, ОтображениеСтраницФормы.Нет);
	
	Форма.Элементы.ГруппаБанкДляРасчетов.Доступность = Форма.ИспользуетсяБанкДляРасчетов;
	
	Форма.Элементы.СпособУказанияРеквизитовБанка.Доступность = Форма.МестоОткрытия = "РФ";
	Если Форма.МестоОткрытия = "ЗаРубежом" Тогда
		Форма.СпособУказанияРеквизитовБанка = "Вручную";
		Форма.Объект.РучноеИзменениеРеквизитовБанка = Истина;
	КонецЕсли;
	
	Форма.Элементы.РеквизитыБанка.Доступность = Форма.СпособУказанияРеквизитовБанка = "Вручную";
	Форма.Элементы.РеквизитыБанкаРасчетов.Доступность = Форма.СпособУказанияРеквизитовБанкаРасчетов = "Вручную";
	
	Форма.Элементы.СпособУказанияРеквизитовБанкаРасчетов.Доступность = Форма.Объект.Валюта = Форма.НациональнаяВалюта;
	Если Форма.Объект.Валюта <> Форма.НациональнаяВалюта Тогда
		Форма.СпособУказанияРеквизитовБанкаРасчетов = "Вручную";
	КонецЕсли;
	
	Форма.Элементы.НаименованиеБанка.Доступность = Форма.Объект.РучноеИзменениеРеквизитовБанка;
	Форма.Элементы.ГородБанка.Доступность		 = Форма.Объект.РучноеИзменениеРеквизитовБанка;
	Форма.Элементы.КоррСчетБанка.Доступность     = Форма.Объект.РучноеИзменениеРеквизитовБанка;
	
	Форма.Элементы.НаименованиеБанкаДляРасчетов.Доступность = Форма.Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;
	Форма.Элементы.ГородБанкаДляРасчетов.Доступность		= Форма.Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;
	Форма.Элементы.КоррСчетБанкаДляРасчетов.Доступность		= Форма.Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;
	
	Форма.Элементы.СостояниеБанка.ТекущаяСтраница = 
		?(Форма.ДеятельностьБанкаПрекращена, Форма.Элементы.БанкЗакрыт, Форма.Элементы.БанкРаботает);
		
	Форма.Элементы.СостояниеБанкаНепрямыхРасчетов.ТекущаяСтраница = 
		?(Форма.ДеятельностьБанкаНепрямыхРасчетовПрекращена, Форма.Элементы.БанкНепрямыхРасчетовЗакрыт, Форма.Элементы.БанкНепрямыхРасчетовРаботает);
		
	Если Форма.МестоОткрытия = "РФ" Тогда
		Форма.Элементы.КодыБанка.ТекущаяСтраница = Форма.Элементы.КодыБанкаРоссийскогоСчета;
	Иначе
		Форма.Элементы.КодыБанка.ТекущаяСтраница = Форма.Элементы.КодыБанкаЗарубежногоСчета;
	КонецЕсли;
	
	Если Форма.Объект.Валюта = Форма.НациональнаяВалюта Тогда
		Форма.Элементы.КодыБанкаРасчетов.ТекущаяСтраница = Форма.Элементы.КодыБанкаРасчетовРублевогоСчета;
	Иначе
		Форма.Элементы.КодыБанкаРасчетов.ТекущаяСтраница = Форма.Элементы.КодыБанкаРасчетовВалютногоСчета;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура РеквизитБанкаПриВыборе(ИмяЭлемента, Форма)
	Если ИмяЭлемента = "БИКБанка" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанка Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
			ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	ИначеЕсли ИмяЭлемента = "БИКБанкаДляРасчетов" Тогда
		Если Не Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
			СтруктураПараметров = Новый Структура;
			СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
			ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ФормаВыбора", СтруктураПараметров, Форма);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаОткрытие(ИмяЭлемента)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Реквизит", ИмяЭлемента);
	ЗначенияПараметров = Новый Структура;
	
	Если ИмяЭлемента = "БИКБанка" Тогда
		
		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанка);
		
		Если Объект.РучноеИзменениеРеквизитовБанка Тогда
			ЗначенияПараметров.Вставить("БИК", БИКБанка);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанка);
			ЗначенияПараметров.Вставить("КоррСчет", КоррСчетБанка);
			ЗначенияПараметров.Вставить("Город", ГородБанка);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанка);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанка);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.Банк);
		КонецЕсли;
		
	ИначеЕсли ИмяЭлемента = "БИКБанкаДляРасчетов" Тогда
		
		СтруктураПараметров.Вставить("РучноеИзменение", Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов);
		
		Если Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов Тогда
			ЗначенияПараметров.Вставить("БИК", БИКБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Наименование", НаименованиеБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("КоррСчет", КоррСчетБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Город", ГородБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Адрес", Объект.АдресБанкаДляРасчетов);
			ЗначенияПараметров.Вставить("Телефоны", Объект.ТелефоныБанкаДляРасчетов);
		Иначе
			СтруктураПараметров.Вставить("Банк", Объект.БанкДляРасчетов);
		КонецЕсли;
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ЗначенияПолей", ЗначенияПараметров);
	ОткрытьФорму("Справочник._ДемоБанковскиеСчета.Форма.РеквизитыБанка",СтруктураПараметров, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзменении(Элемент)
	
	ТипБанка = "Банк";
	РучноеИзменениеРеквизитовБанка = Объект.РучноеИзменениеРеквизитовБанка;
	ИмяРедактируемогоРеквизита = "БИКБанка";

	Если СтрНачинаетсяС(Элемент.Имя, "БИКБанкаДляРасчетов") Тогда 
		ТипБанка = "БанкДляРасчетов";
		РучноеИзменениеРеквизитовБанка = Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов;
		ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	КонецЕсли;
	
	Если РучноеИзменениеРеквизитовБанка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполнитьРеквизитыБанкаПоБИК(ЭтотОбъект[ИмяРедактируемогоРеквизита], ТипБанка, Истина) Тогда
		УправлениеЭлементамиФормы(ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
	СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
	СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка", НСтр("ru = 'Выбрать из списка'"));
	СписокВариантовОтветовНаВопрос.Добавить("ПродолжитьВвод", НСтр("ru = 'Продолжить ввод'"));
	СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод", НСтр("ru = 'Отменить ввод'"));
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Банк с БИК %1 не найден в классификаторе банков.'"), ЭтотОбъект[ИмяРедактируемогоРеквизита]);
		
	ОписаниеОповещения = Новый ОписаниеОповещения("РеквизитБанкаПриИзмененииЗавершение", ЭтотОбъект, Элемент);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокВариантовОтветовНаВопрос, 0, , НСтр("ru = 'Выбор банка из классификатора'"));
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитБанкаПриИзмененииЗавершение(РезультатВопроса, Элемент) Экспорт
	
	ИмяРедактируемогоРеквизита = "БИКБанка";
	Если СтрНачинаетсяС(Элемент.Имя, "БИКБанкаДляРасчетов") Тогда 
		ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов";
	КонецЕсли;

	Если РезультатВопроса = "ОтменитьВвод" Тогда
		ЭтотОбъект[ИмяРедактируемогоРеквизита] = "";
	ИначеЕсли РезультатВопроса = "ПродолжитьВвод" Тогда
		Если ИмяРедактируемогоРеквизита = "БИКБанка" Тогда 
			Объект.РучноеИзменениеРеквизитовБанка = Истина;
		ИначеЕсли ИмяРедактируемогоРеквизита = "БИКБанкаДляРасчетов" Тогда 
			Объект.РучноеИзменениеРеквизитовБанкаДляРасчетов = Истина;
		КонецЕсли;
		Объект[ИмяРедактируемогоРеквизита] = ЭтотОбъект[ИмяРедактируемогоРеквизита];
	ИначеЕсли РезультатВопроса = "ВыбратьИзСписка" Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Реквизит", ИмяРедактируемогоРеквизита);
		ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ФормаВыбора", СтруктураПараметров, ЭтотОбъект);
	КонецЕсли;
	
	УправлениеЭлементамиФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДеятельностьБанкаПрекращена(БИК)
	
	Результат = Ложь;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.ДеятельностьПрекращена
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Код = &БИК
	|	И КлассификаторБанковРФ.ЭтоГруппа = ЛОЖЬ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ДеятельностьПрекращена;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьТекстПоясненияНедействительностиБанка()
	Элементы.НадписьДеятельностьБанкаПрекращена.Заголовок = РаботаСБанками.ПояснениеНедействительногоБанка(Объект.Банк);
	Элементы.НадписьДеятельностьБанкаРасчетовПрекращена.Заголовок =РаботаСБанками.ПояснениеНедействительногоБанка(Объект.БанкДляРасчетов);
КонецПроцедуры

#КонецОбласти
