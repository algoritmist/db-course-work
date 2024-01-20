
Create function find_person(ИД_З int, ИДЧ_Ц int)
Returns void AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	endif;
	main_worker := any(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента'));
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	pg_sleep(3);

	--INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД,ЦЕЛЬ_ПРЕДМЕТ_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА=’Устроить войну’), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ=’ОБРАБАТЫВАЕТСЯ’), ИДЧ_Ц, ИДП_Ц);
	ask := INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА=’Найти человека’), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ=’ОБРАБАТЫВАЕТСЯ’), ИДЧ_Ц) returning ИД;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	endif;
	second_worker := any(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел'));
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	pg_sleep(3);
	
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') then
		RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -1;
	endif;


	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	contract := insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ') returning ИД;
	--journal := insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ') returning ИД;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Отдел поиска людей')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	endif;
	second_worker := any(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел поиска людей'));
	pg_sleep(3);
	



	If exists(SELECT * FROM РАБОТНИК where ОТДЕЛ_ИД = (SELECT ИД FROM ОТДЕЛ where НАЗВАНИЕ=’ФИНАНСОВЫЙ ОТДЕЛ’) and СТАТУС_РАБОТНИКА=’Свободен’) then RAISE NOTICE 'Сейчас нет свободных сотрудников, заявка будет обработана позже';
	Else 
		RAISE NOTICE 'Работает финансовый отдел';
		//Подсчет стоимости
		If (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)<100 then
			RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		Else
			
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
