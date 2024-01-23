
Create function find_person(ИД_З int, ИМЯ_З varchar, ФАМИЛИЯ_З varchar)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК  where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Найти человека'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);
	
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') then
		RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -2;
	end if;


	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел поиска людей'),CURDATE) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Отдел поиска людей')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -3;
	end if;
	select * into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел поиска людей');
	select pg_sleep(3);

	if not exists(select * from ЧЕЛОВЕК where ИМЯ=ИМЯ_З and ФАМИЛИЯ=ФАМИЛИЯ_З) then
		raise notice 'Запрашиваемый человек не найден';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE where ИД=journal;
		update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		return -4;
	end if;
	select МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК where ИМЯ=ИМЯ_З and ФАМИЛИЯ=ФАМИЛИЯ_З;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;

Create function find_object(ИД_З int, ПРЕДМЕТ_З varchar)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Найти предмет'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);
	
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') then
		RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -2;
	end if;


	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Торговый отдел'),CURDATE) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Торговый отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -3;
	end if;
	 select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Торговый отдел');
	select pg_sleep(3);

	if not exists(select * from ПРЕДМЕТ where НАЗВАНИЕ=ПРЕДМЕТ_З) then
		raise notice 'Предмет не найден';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE where ИД=journal;
		update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		return -4;
	end if;
	select ИД into result_id from ЧЕЛОВЕК inner join ПРЕДМЕТ on ЧЕЛОВЕК.ИД=ПРЕДМЕТ.ЧЛВК_ИД where ПРЕДМЕТ.НАЗВАНИЕ=ПРЕДМЕТ_З;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return result_id;
End;
$$ language plpgsql;

Create function war(ИД_З int, ИД_Ц int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
	sum_damage int :=0;
	sum_health int :=0;
	warrior int :=0;
	min_count int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	if exists(select * from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where СТАТУС_РАСШИФРОВКА='Император' and ЧЛВК_ИД=ИД_Ц) then
		raise notice 'НЕЛЬЗЯ НАПАДАТЬ НА ИМПЕРАТОРА';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		return -1;
	end if;
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Устроить войну'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);

	select sum(ЗДОРОВЬЕ+БРОНЯ+БОНУС_К_БРОНЕ) into sum_health from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА where ИД_ПРЕДВОДИТЕЛЯ=ИД_Ц;
	select sum(ОРУЖИЕ+БОНУС_К_ОРУЖИЮ+БОНУС_К_МАГИИ+Урон) into sum_damage from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА inner join ВОИН_ЗАКЛИНАНИЕ on ВОИН.ЧЛВК_ИД=ВОИН_ЗАКЛИНАНИЕ.ИД_ВОИНА inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЕ.Название=ЗАКЛИНАНИЕ.Название where ИД_ПРЕДВОДИТЕЛЯ=ИД_Ц group by ЧЛВК_ИД ;

	select min(count) into min_count from (select ИД_ПРЕДВОДИТЕЛЯ,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА  inner join ВОИН_ЗАКЛИНАНИЕ on ВОИН.ЧЛВК_ИД=ВОИН_ЗАКЛИНАНИЕ.ИД_ВОИНА inner join ЗАКЛИНАНИЕ on ВОИН_ЗАКЛИНАНИЕ.Название=ЗАКЛИНАНИЕ.Название
                where СТАТУС.РАСШИФРОВКА='СОЛДАТ' and ИД_ПРЕДВОДИТЕЛЯ<>ИД_Ц group by ИД_ПРЕДВОДИТЕЛЯ having sum(ЗДОРОВЬЕ+БРОНЯ+БОНУС_К_БРОНЕ)>=sum_damage and sum(ОРУЖИЕ+БОНУС_К_ОРУЖИЮ+БОНУС_К_МАГИИ+Урон)>=sum_health) as cnt;
	if min_count<=0 then
		raise notice 'Не достаточно войск для нападения';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -3;
	end if;
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет')*min_count then
		raise notice 'Не достаточно денег';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -4;
	end if;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),CURDATE) Returning ИД into journal;

	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');
	select pg_sleep(3);

	select min(ИД_ПРЕДВОДИТЕЛЯ) into warrior from (select ИД_ПРЕДВОДИТЕЛЯ,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                group by ИД_ПРЕДВОДИТЕЛЯ) as cnt where count=min_count and ИД_ПРЕДВОДИТЕЛЯ<>ИД_Ц;

	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ИД_ПРЕДВОДИТЕЛЯ = ИД_Ц);
	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ЧЛВК_ИД = ИД_Ц);
	delete from ВОИН where ИД_ПРЕДВОДИТЕЛЯ = ИД_Ц;
	delete from ВОИН where ЧЛВК_ИД = ИД_Ц;
	-- удаление достаточного кол-ва людей из нанимаемой армии происходит на беке

	select ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК inner join МЕСТОПОЛОЖЕНИЕ on ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ=МЕСТОПОЛОЖЕНИЕ_ИД where ЧЕЛОВЕК.ИД=ИД_Ц;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return result_id;
End;
$$ language plpgsql;


Create function war_for_item(ИД_З int, ИД_П_Ц int, ИД_Ч_Ц int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
	sum_damage int :=0;
	sum_health int :=0;
	warrior int :=0;
	min_count int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	if exists(select * from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where СТАТУС_РАСШИФРОВКА='Император' and ЧЛВК_ИД=ИД_Ц) then
		raise notice 'НЕЛЬЗЯ НАПАДАТЬ НА ИМПЕРАТОРА';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		return -1;
	end if;
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Устроить войну'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);

	select sum(ЗДОРОВЬЕ+БРОНЯ+БОНУС_К_БРОНЕ) into sum_health from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА where ИД_ПРЕДВОДИТЕЛЯ=ИД_Ц;
	select sum(ОРУЖИЕ+БОНУС_К_ОРУЖИЮ+БОНУС_К_МАГИИ+Урон) into sum_damage from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА inner join ВОИН_ЗАКЛИНАНИЕ on ВОИН.ЧЛВК_ИД=ВОИН_ЗАКЛИНАНИЕ.ИД_ВОИНА inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЕ.Название=ЗАКЛИНАНИЕ.Название where ИД_ПРЕДВОДИТЕЛЯ=ИД_Ц group by ЧЛВК_ИД ;

	select min(count) into min_count from (select ИД_ПРЕДВОДИТЕЛЯ,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                inner join ТИП_ВОИНА on ТИП_ВОИНА.НАЗВАНИЕ=ВОИН.ТИП_ВОИНА  inner join ВОИН_ЗАКЛИНАНИЕ on ВОИН.ЧЛВК_ИД=ВОИН_ЗАКЛИНАНИЕ.ИД_ВОИНА inner join ЗАКЛИНАНИЕ on ВОИН_ЗАКЛИНАНИЕ.Название=ЗАКЛИНАНИЕ.Название
                where СТАТУС.РАСШИФРОВКА='СОЛДАТ' and ИД_ПРЕДВОДИТЕЛЯ<>ИД_Ц group by ИД_ПРЕДВОДИТЕЛЯ having sum(ЗДОРОВЬЕ+БРОНЯ+БОНУС_К_БРОНЕ)>=sum_damage and sum(ОРУЖИЕ+БОНУС_К_ОРУЖИЮ+БОНУС_К_МАГИИ+Урон)>=sum_health) as cnt;
	if min_count<=0 then
		raise notice 'Не достаточно войск для нападения';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -3;
	end if;
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет')*min_count then
		raise notice 'Не достаточно денег';
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
		return -4;
	end if;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),CURDATE) Returning ИД into journal;

	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');
	select pg_sleep(3);

	select min(ИД_ПРЕДВОДИТЕЛЯ) into warrior from (select ИД_ПРЕДВОДИТЕЛЯ,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                group by ИД_ПРЕДВОДИТЕЛЯ) as cnt where count=min_count and ИД_ПРЕДВОДИТЕЛЯ<>ИД_Ц;

	 
	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ИД_ПРЕДВОДИТЕЛЯ = ИД_Ц);
	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = ИД_Ц and ИД<>ИД_П_Ц;
	update ПРЕДМЕТ set ЧЛВК_ИД=ЧЛВК_З where ЧЛВК_ИД = ИД_Ц and ИД=ИД_П_Ц;
	delete from ВОИН where ИД_ПРЕДВОДИТЕЛЯ = ИД_Ц;
	delete from ВОИН where ЧЛВК_ИД = ИД_Ц;
	-- удаление достаточного кол-ва людей из нанимаемой армии происходит на беке

	select ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК inner join МЕСТОПОЛОЖЕНИЕ on ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ=МЕСТОПОЛОЖЕНИЕ_ИД where ЧЕЛОВЕК.ИД=ИД_Ц;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;

Create function be_warrior(ИД_З int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Стать воином'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)+(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Стать воином') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),CURDATE) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Военный отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');
	select pg_sleep(3);

	insert into ВОИН(ЧЛВК_ИД,ЗДОРОВЬЕ, ОРУЖИЕ, БРОНЯ) values(ИД_З,floor(RAND()*100),floor(RAND()*100),floor(RAND()*100));
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return 0;
End;
$$ language plpgsql;

Create function be_leader(ИД_З int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = main_worker;
	select pg_sleep(3);

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_А, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Стать предводителем'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИДЧ_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=1 where ЧЛВК_ИД = second_worker;
	select pg_sleep(3);

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_А)+(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Стать предводителем') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(НОМЕР_ЗАЯВКИ, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ_ИД, ОТДЕЛ_ИД, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),CURDATE) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Военный отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=0 and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');
	select pg_sleep(3);

	insert into ВОИН(ЧЛВК_ИД,ЗДОРОВЬЕ, ОРУЖИЕ, БРОНЯ) values(ИД_З,floor(RAND()*100),floor(RAND()*100),floor(RAND()*100));
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ИСПОЛНЕНИЯ=CURDATE where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=0 where ЧЛВК_ИД = main_worker;
	return 0;
End;
$$ language plpgsql;
