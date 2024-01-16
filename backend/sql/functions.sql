
Create function war(ИД_А int, ИДЧ_Ц int)
Returns void AS $$
BEGIN
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД,ЦЕЛЬ_ПРЕДМЕТ_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА=’Устроить войну’), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ=’ОБРАБАТЫВАЕТСЯ’), ИДЧ_Ц, ИДП_Ц);
	If exists(SELECT * FROM РАБОТНИК where ОТДЕЛ_ИД = (SELECT ИД FROM ОТДЕЛ where НАЗВАНИЕ=’ФИНАНСОВЫЙ ОТДЕЛ’) and СТАТУС_РАБОТНИКА=’Свободен’) then RAISE NOTICE 'Сейчас нет свободных сотрудников, заявка будет обработана позже';
	Else 
		RAISE NOTICE 'Работает финансовый отдел';
		//Подсчет стоимости
		If (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)<100 then
			RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		Else
			Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-100 where ИД=ИД_А;
			INSERT INTO КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘ЗАЯВКА’,’ИД’))-1, select * from СТАТУС_КОНТРАКТА where ОПИСАНИЕ=’ВЫПОЛНЯЕТСЯ’));
			Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘КОНТРАКТ’,’ИД’))-1, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ=’ВОЕННЫЙ ОТДЕЛ’),CURDATE);
		Endif;
	Endif;
End;
$$ language plpgsql;

Create function find_person(ИД_А int, ИДЧ_Ц int)
Returns void AS $$
BEGIN
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА=’Найти человека’), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ=’ОБРАБАТЫВАЕТСЯ’), ИДЧ_Ц);
	If exists(SELECT * FROM РАБОТНИК where ОТДЕЛ_ИД = (SELECT ИД FROM ОТДЕЛ where НАЗВАНИЕ=’ФИНАНСОВЫЙ ОТДЕЛ’) and СТАТУС_РАБОТНИКА=’Свободен’) then RAISE NOTICE 'Сейчас нет свободных сотрудников, заявка будет обработана позже';
	Else 
		RAISE NOTICE 'Работает финансовый отдел';
		//Подсчет стоимости
		If (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)<100 then
			RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		Else
			Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-100 where ИД=ИД_А;
			INSERT INTO КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘ЗАЯВКА’,’ИД’))-1, select * from СТАТУС_КОНТРАКТА where ОПИСАНИЕ=’ВЫПОЛНЯЕТСЯ’));
			Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘КОНТРАКТ’,’ИД’))-1, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ=’ОТДЕЛ ПОИСКА ЛЮДЕЙ’),CURDATE);
		Endif;
	Endif;
End;
$$ language plpgsql;

Create function buy_item(ИД_А int, ИДП_Ц int)
Returns void AS $$
BEGIN
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ПРЕДМЕТ_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА=’Покупка предмета’), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ=’ОБРАБАТЫВАЕТСЯ’), ИДП_Ц);
	If exists(SELECT * FROM РАБОТНИК where ОТДЕЛ_ИД = (SELECT ИД FROM ОТДЕЛ where НАЗВАНИЕ=’ФИНАНСОВЫЙ ОТДЕЛ’) and СТАТУС_РАБОТНИКА=’Свободен’) then RAISE NOTICE 'Сейчас нет свободных сотрудников, заявка будет обработана позже';
	Else 
		RAISE NOTICE 'Работает финансовый отдел';
		//Подсчет стоимости
		If (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)<100 then
			RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		Else
			Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-100 where ИД=ИД_А;
			INSERT INTO КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘ЗАЯВКА’,’ИД’))-1, select * from СТАТУС_КОНТРАКТА where ОПИСАНИЕ=’ВЫПОЛНЯЕТСЯ’));
			Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(CURVAL(PG_GET_SERIAL_SEQUENCE(‘КОНТРАКТ’,’ИД’))-1, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ=’ОТДЕЛ ПОКУПКИ ПРЕДМЕТОВ’),CURDATE);
		Endif;
	Endif;
End;
$$ language plpgsql;
