﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ТоварыНаСкладах.Записывать = Истина;
	Движения.Продажи.Записывать = Истина;
	Движения.УчетЗатрат.Записывать = Истина;
	Движения.ЗаказКлиентов.Записывать = Истина;
	Движения.Хозрасчетный.Записывать = Истина;
	
	Движения.ТоварыНаСкладах.Записать();
	Движения.Продажи.Записать();
	Движения.УчетЗатрат.Записать();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ТоварыНаСкладах");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = Товары;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад","Склад");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровИУслугТовары.Номенклатура КАК Номенклатура,
	|	РеализацияТоваровИУслугТовары.Склад КАК Склад,
	|	СУММА(РеализацияТоваровИУслугТовары.Количество) КАК Количество,
	|	СУММА(РеализацияТоваровИУслугТовары.Сумма) КАК Сумма
	|ПОМЕСТИТЬ ВТ_Товары
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТоваровИУслугТовары
	|ГДЕ
	|	РеализацияТоваровИУслугТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровИУслугТовары.Номенклатура,
	|	РеализацияТоваровИУслугТовары.Склад
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РеализацияТоваровИУслугУслуги.Номенклатура,
	|	NULL,
	|	СУММА(РеализацияТоваровИУслугУслуги.Количество),
	|	СУММА(РеализацияТоваровИУслугУслуги.Сумма)
	|ИЗ
	|	Документ.РеализацияТоваровИУслуг.Услуги КАК РеализацияТоваровИУслугУслуги
	|ГДЕ
	|	РеализацияТоваровИУслугУслуги.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	РеализацияТоваровИУслугУслуги.Номенклатура
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Товары.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ВТ_Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипНоменклатуры.Услуга)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЭтоТовар,
	|	ВТ_Товары.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ВТ_Товары.Количество КАК КоличествоВДокументе,
	|	ВТ_Товары.Сумма КАК СуммаВДокументе,
	|	ВТ_Товары.Склад КАК Склад,
	|	ТоварыНаСкладахОстатки.СрокГодности КАК СрокГодности,
	|	ЕСТЬNULL(ТоварыНаСкладахОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	|	ЕСТЬNULL(ТоварыНаСкладахОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|	ВТ_Товары.Номенклатура.СтатьяЗатрат КАК СтатьяЗатрат,
	|	ВТ_Товары.Номенклатура.СчетБухгалтерскогоУчета КАК СчетБухгалтерскогоУчета
	|ИЗ
	|	ВТ_Товары КАК ВТ_Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыНаСкладах.Остатки(
	|				&МоментВремени,
	|				(Номенклатура, Склад) В
	|					(ВЫБРАТЬ
	|						ВТ_Товары.Номенклатура,
	|						ВТ_Товары.Склад
	|					ИЗ
	|						ВТ_Товары КАК ВТ_Товары)) КАК ТоварыНаСкладахОстатки
	|		ПО ВТ_Товары.Номенклатура = ТоварыНаСкладахОстатки.Номенклатура
	|			И ВТ_Товары.Склад = ТоварыНаСкладахОстатки.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	СрокГодности
	|ИТОГИ
	|	МАКСИМУМ(КоличествоВДокументе),
	|	МАКСИМУМ(СуммаВДокументе),
	|	СУММА(КоличествоОстаток)
	|ПО
	|	Номенклатура";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(МоментВремени())); 
	
	ВыборкаНоменклатура = 
	Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		Если ВыборкаНоменклатура.ЭтоТовар Тогда
			
			СтоимостьОбщая = 0;
			
			Превышение = ВыборкаНоменклатура.КоличествоВДокументе - ВыборкаНоменклатура.КоличествоОстаток;
			Если Превышение > 0 Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтрШаблон("Превышение остатков по номенклатуре ""%1"" в количестве ""%2""", ВыборкаНоменклатура.НоменклатураПредставление, Превышение);
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;
			
			Если Отказ Тогда
				Продолжить;
			КонецЕсли;
			
			
			ОсталосьСписать = ВыборкаНоменклатура.КоличествоВДокументе;
			
			ВыборкаДетальные = ВыборкаНоменклатура.Выбрать();
			Пока ВыборкаДетальные.Следующий() и ОсталосьСписать > 0 Цикл
				Списываем = Мин (ВыборкаДетальные.КоличествоОстаток, ОсталосьСписать);
				
				Движение = Движения.ТоварыНаСкладах.ДобавитьРасход();
				Движение.Период = Дата;
				Движение.Номенклатура = ВыборкаДетальные.Номенклатура;
				Движение.Склад = ВыборкаДетальные.Склад;
				Движение.СрокГодности = ВыборкаДетальные.СрокГодности;
				Движение.Количество = Списываем;
				Если Списываем = ВыборкаДетальные.КоличествоОстаток Тогда
					СуммаСписания = ВыборкаДетальные.СуммаОстаток;
				Иначе
					СуммаСписания = Списываем / ВыборкаДетальные.КоличествоОстаток * ВыборкаДетальные.СуммаОстаток;
				КонецЕсли;
				Движение.Сумма = СуммаСписания;
				
				ОсталосьСписать = ОсталосьСписать - Списываем;
				СтоимостьОбщая = СтоимостьОбщая + Движение.Сумма;
				
				Движение = Движения.Хозрасчетный.Добавить();
				Движение.СчетДт = ПланыСчетов.Хозрасчетный.Продажи;
				Движение.СчетКт = ВыборкаНоменклатура.СчетБухгалтерскогоУчета;
				Движение.СубконтоКт[ПланывидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура] = ВыборкаДетальные.Номенклатура;
				Движение.Период = Дата;
				Движение.Сумма = СуммаСписания;
				Движение.Содержание = "Списана себестоимость товарно-материальных ценностей";	
				
				
				
			КонецЦикла;
			
			Движение = Движения.УчетЗатрат.Добавить();
			Движение.Период = Дата;
			Движение.СтатьяЗатрат = ВыборкаНоменклатура.СтатьяЗатрат;
			Движение.Сумма = СтоимостьОбщая;
			
		Иначе
			Движение = Движения.ЗаказКлиентов.Добавить();
			Движение.Номенклатура = ВыборкаНоменклатура.Номенклатура;
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Клиент = Клиент;
			Движение.ДатаЗаписи = ДатаОказанияУслуг;
			Движение.Количество = ВыборкаНоменклатура.КоличествоВДокументе;
			Движение.Сумма = ВыборкаНоменклатура.СуммаВДокументе;
			
		КонецЕсли;
		
		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата; 
		Движение.Номенклатура = ВыборкаНоменклатура.Номенклатура;
		Движение.Сотрудники = Сотрудник;
		Движение.Клиент = Клиент;
		Движение.Сумма = ВыборкаНоменклатура.СуммаВДокументе;
		Движение.Количество = ВыборкаНоменклатура.КоличествоВДокументе;
				
		
	КонецЦикла;  
	
	Движение = Движения.Хозрасчетный.Добавить();
	Движение.СчетДт = планысчетов.Хозрасчетный.РасчетыСПокупателями;
	Движение.СчетКт = ПланыСчетов.Хозрасчетный.Продажи;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, Клиент);
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = "Отражена выручка от  реализации товаров и услуг";
	
	Движения.ЗаказКлиентов.БлокироватьДляИзменения = Истина;
	Движения.ЗаказКлиентов.Записать(); 
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказКлиентовОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|	ЗаказКлиентовОстатки.Клиент КАК Клиент,
	|	ЗаказКлиентовОстатки.ДатаЗаписи КАК ДатаЗаписи,
	|	ЗаказКлиентовОстатки.Клиент.Представление КАК КлиентПредставление,
	|	ЗаказКлиентовОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказКлиентовОстатки.Номенклатура.Представление КАК НоменклатураПредставление
	|ИЗ
	|	РегистрНакопления.ЗаказКлиентов.Остатки(
	|			&МоментВремени,
	|			Клиент = &Клиент
	|				И ДатаЗаписи = &ДатаЗаписи
	|				И Номенклатура В
	|					(ВЫБРАТЬ
	|						ВТ_Товары.Номенклатура
	|					ИЗ
	|						ВТ_Товары КАК ВТ_Товары
	|					ГДЕ
	|						ВТ_Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипНоменклатуры.Услуга))) КАК ЗаказКлиентовОстатки
	|ГДЕ
	|	ЗаказКлиентовОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(МоментВремени()));
	Запрос.УстановитьПараметр("Клиент", Клиент);
	Запрос.УстановитьПараметр("ДатаЗаписи", ДатаОказанияУслуг);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Услуга ""%1"" для клиента ""%2"" на дату ""%3"" уже была обработана или не была найдена такая запись!", Выборка.НоменклатураПредставление,Выборка.КлиентПредставление, Формат(Выборка.ДатаЗаписи, "ДФ=dd.MM.yy"));
			Сообщение.Сообщить();
		КонецЦикла;	 
	КонецЕсли;
	
	
	
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаписьКлиента") Тогда  
		
		ДокументОснование = ДанныеЗаполнения; 
		АвторДокумента = ДанныеЗаполнения.АвторДокумента;
		ДатаОказанияУслуг = ДанныеЗаполнения.ДатаЗаписи;
		Клиент = ДанныеЗаполнения.Клиент;
		Коментарий = ДанныеЗаполнения.Коментарий;
		Сотрудник = ДанныеЗаполнения.Сотрудники;
		Для Каждого ТекСтрокаУслуги Из ДанныеЗаполнения.Услуги Цикл
			НоваяСтрока = Услуги.Добавить();
			НоваяСтрока.Количество = ТекСтрокаУслуги.Количество;
			НоваяСтрока.Номенклатура = ТекСтрокаУслуги.Номенклатура;
			НоваяСтрока.Сумма = ТекСтрокаУслуги.Сумма;
			НоваяСтрока.Цена = ТекСтрокаУслуги.Цена;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ ЗначениеЗаполнено(АвторДокумента) Тогда	
		АвторДокумента = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли; 
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	
	Если ЗначениеЗаполнено(Ссылка)
		И ПризнакОплаты <> Перечисления.ОплатаДокумента.ПолностьюОплачен Тогда
		СтруктураОплаты = Документы.РеализацияТоваровИУслуг.ПроверитьОплатуДокумента(Ссылка);
		ПризнакОплаты = СтруктураОплаты.ПризнакОплаты;
	КонецЕсли;

		
КонецПроцедуры




	
