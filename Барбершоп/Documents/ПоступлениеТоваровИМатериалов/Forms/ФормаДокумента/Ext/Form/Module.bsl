﻿
&НаКлиенте
Процедура ОсновыПрограммирования(Команда)
;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
СтрокаТЧ = Элементы.Товары.ТекущиеДанные;

Если ЗначениеЗаполнено(СтрокаТЧ.Номенклатура) Тогда
	СтрокаТЧ.Цена = РаботаСЦенами.ПолучитьЦенуПродажиНаДату(СтрокаТЧ.Номенклатура);
Иначе
	СтрокаТЧ.Цена = 0;
КонецЕсли;

РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТЧ = Элементы.Товары.ТекущиеДанные;
	
	РаботаСтабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТЧ)
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
СтрокаТЧ = Элементы.Товары.ТекущиеДанные;

РаботаСтабличнымиЧастямиКлиент.ПересчитатьЦенуВСтрокеТабличнойЧасти(СтрокаТЧ);
КонецПроцедуры



