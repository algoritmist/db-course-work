
Create or replace function find_person(ИД_З int, ИМЯ_З varchar, ФАМИЛИЯ_З varchar)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК  where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Найти человека'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ')) returning ИД into ask;
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') then
		RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -2;
	end if;


	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти человека') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел поиска людей'),current_date) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Отдел поиска людей')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -3;
	end if;
	select * into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел поиска людей');
	
	if not exists(select * from ЧЕЛОВЕК where ИМЯ=ИМЯ_З and ФАМИЛИЯ=ФАМИЛИЯ_З) then
		raise notice 'Запрашиваемый человек не найден';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date where ИД=journal;
		update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		return -4;
	end if;
	select МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК where ИМЯ=ИМЯ_З and ФАМИЛИЯ=ФАМИЛИЯ_З;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;

Create or replace function find_object(ИД_З int, ПРЕДМЕТ_З varchar)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Найти предмет'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ')) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;
	
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') then
		RAISE NOTICE 'Недостаточно средств, заявка отклонена';
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -2;
	end if;


	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Торговый отдел'),current_date) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Торговый отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -3;
	end if;
	 select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Торговый отдел');

	if not exists(select * from ПРЕДМЕТ where НАЗВАНИЕ=ПРЕДМЕТ_З) then
		raise notice 'Предмет не найден';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date where ИД=journal;
		update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		return -4;
	end if;
	select ИД into result_id from ЧЕЛОВЕК inner join ПРЕДМЕТ on ЧЕЛОВЕК.ИД=ПРЕДМЕТ.ЧЛВК_ИД where ПРЕДМЕТ.НАЗВАНИЕ=ПРЕДМЕТ_З;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;

Create or replace function war(ИД_З int, ИД_Ц int)
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
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return 1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;

	if exists(select * from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where НАЗВАНИЕ='Император' and ЧЛВК_ИД=ИД_Ц) then
		raise notice 'НЕЛЬЗЯ НАПАДАТЬ НА ИМПЕРАТОРА';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		return -1;
	end if;
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Устроить войну'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИД_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;

	select sum(ЗДОРОВЬЕ+БРОНЯ+ЗАЩИТА) into sum_health from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА where ПРЕДВОДИТЕЛЬ_ИД=ИД_Ц;
	select sum(ОРУЖИЕ+АТАКА+БОНУС_К_МАГИИ+УРОН) into sum_damage from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА inner join ЗАКЛИНАНИЯ_ВОИНА on ВОИН.ЧЛВК_ИД=ЗАКЛИНАНИЯ_ВОИНА.ВОИН_ИД inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЯ_ВОИНА.ЗАКЛИНАНИЕ_НАЗВАНИЕ=ЗАКЛИНАНИЕ.НАЗВАНИЕ where ПРЕДВОДИТЕЛЬ_ИД=ИД_Ц group by ЧЛВК_ИД ;

	select min(count) into min_count from (select ПРЕДВОДИТЕЛЬ_ИД,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА  inner join ЗАКЛИНАНИЯ_ВОИНА on ВОИН.ЧЛВК_ИД=ЗАКЛИНАНИЯ_ВОИНА.ВОИН_ИД inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЯ_ВОИНА.ЗАКЛИНАНИЕ_НАЗВАНИЕ=ЗАКЛИНАНИЕ.НАЗВАНИЕ
                where СТАТУС.НАЗВАНИЕ='СОЛДАТ' and ПРЕДВОДИТЕЛЬ_ИД<>ИД_Ц group by ПРЕДВОДИТЕЛЬ_ИД having sum(ЗДОРОВЬЕ+БРОНЯ+ЗАЩИТА)>=sum_damage and sum(ОРУЖИЕ+АТАКА+БОНУС_К_МАГИИ+УРОН)>=sum_health) as cnt;
	if min_count<=0 then
		raise notice 'Не достаточно войск для нападения';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -3;
	end if;
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет')*min_count then
		raise notice 'Не достаточно денег';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -4;
	end if;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),current_date) Returning ИД into journal;

	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');

	select min(ПРЕДВОДИТЕЛЬ_ИД) into warrior from (select ПРЕДВОДИТЕЛЬ_ИД,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                group by ПРЕДВОДИТЕЛЬ_ИД) as cnt where count=min_count and ПРЕДВОДИТЕЛЬ_ИД<>ИД_Ц;

	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ПРЕДВОДИТЕЛЬ_ИД = ИД_Ц);
	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ЧЛВК_ИД = ИД_Ц);
	delete from ВОИН where ПРЕДВОДИТЕЛЬ_ИД = ИД_Ц;
	delete from ВОИН where ЧЛВК_ИД = ИД_Ц;
	-- удаление достаточного кол-ва людей из нанимаемой армии происходит на беке

	select ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК inner join МЕСТОПОЛОЖЕНИЕ on ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ=МЕСТОПОЛОЖЕНИЕ.ИД where ЧЕЛОВЕК.ИД=ИД_Ц;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;


Create or replace function war_for_item(ИД_З int, ИД_П_Ц int, ИД_Ц int)
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
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return 1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;

	if exists(select * from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where НАЗВАНИЕ='Император' and ЧЛВК_ИД=ИД_Ц) then
		raise notice 'НЕЛЬЗЯ НАПАДАТЬ НА ИМПЕРАТОРА';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		return -1;
	end if;
	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ,ЦЕЛЬ_ЧЛВК_ИД) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Устроить войну'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ'), ИД_Ц) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;

	select sum(ЗДОРОВЬЕ+БРОНЯ+ЗАЩИТА) into sum_health from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА where ПРЕДВОДИТЕЛЬ_ИД=ИД_Ц;
	select sum(ОРУЖИЕ+АТАКА+БОНУС_К_МАГИИ+УРОН) into sum_damage from ВОИН inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА inner join ЗАКЛИНАНИЯ_ВОИНА on ВОИН.ЧЛВК_ИД=ЗАКЛИНАНИЯ_ВОИНА.ВОИН_ИД inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЯ_ВОИНА.ЗАКЛИНАНИЕ_НАЗВАНИЕ=ЗАКЛИНАНИЕ.НАЗВАНИЕ where ПРЕДВОДИТЕЛЬ_ИД=ИД_Ц group by ЧЛВК_ИД ;

	select min(count) into min_count from (select ПРЕДВОДИТЕЛЬ_ИД,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                inner join ТИП_ВОИНА on ТИП_ВОИНА.ТИП=ВОИН.ТИП_ВОИНА  inner join ЗАКЛИНАНИЯ_ВОИНА on ВОИН.ЧЛВК_ИД=ЗАКЛИНАНИЯ_ВОИНА.ВОИН_ИД inner join ЗАКЛИНАНИЕ on ЗАКЛИНАНИЯ_ВОИНА.ЗАКЛИНАНИЕ_НАЗВАНИЕ=ЗАКЛИНАНИЕ.НАЗВАНИЕ
                where СТАТУС.НАЗВАНИЕ='СОЛДАТ' and ПРЕДВОДИТЕЛЬ_ИД<>ИД_Ц group by ПРЕДВОДИТЕЛЬ_ИД having sum(ЗДОРОВЬЕ+БРОНЯ+ЗАЩИТА)>=sum_damage and sum(ОРУЖИЕ+АТАКА+БОНУС_К_МАГИИ+УРОН)>=sum_health) as cnt;
	if min_count<=0 then
		raise notice 'Не достаточно войск для нападения';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -3;
	end if;
	if (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)<(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет')*min_count then
		raise notice 'Не достаточно денег';
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
		return -4;
	end if;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)-(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Найти предмет') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),current_date) Returning ИД into journal;

	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');

	select min(ПРЕДВОДИТЕЛЬ_ИД) into warrior from (select ПРЕДВОДИТЕЛЬ_ИД,count(*) from ВОИН inner join ЧЕЛОВЕК on ЧЕЛОВЕК.ИД=ВОИН.ЧЛВК_ИД inner join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД
                group by ПРЕДВОДИТЕЛЬ_ИД) as cnt where count=min_count and ПРЕДВОДИТЕЛЬ_ИД<>ИД_Ц;

	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ПРЕДВОДИТЕЛЬ_ИД = ИД_Ц);
	update ПРЕДМЕТ set ЧЛВК_ИД=null where ЧЛВК_ИД = any(select ЧЛВК_ИД from ВОИН where ЧЛВК_ИД = ИД_Ц);
	update ПРЕДМЕТ set ЧЛВК_ИД=ИД_З where ИД=ИД_П_Ц;
	delete from ВОИН where ПРЕДВОДИТЕЛЬ_ИД = ИД_Ц;
	delete from ВОИН where ЧЛВК_ИД = ИД_Ц;
	-- удаление достаточного кол-ва людей из нанимаемой армии происходит на беке

	select ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ into result_id from ЧЕЛОВЕК inner join МЕСТОПОЛОЖЕНИЕ on ЧЕЛОВЕК.МЕСТОПОЛОЖЕНИЕ=МЕСТОПОЛОЖЕНИЕ.ИД where ЧЕЛОВЕК.ИД=ИД_Ц;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date, МЕСТО_ПРОВЕДЕНИЯ=result_id where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return journal;
End;
$$ language plpgsql;

Create or replace function be_warrior(ИД_З int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Стать воином'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ')) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)+(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Стать воином') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),current_date) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Военный отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');

	insert into ВОИН(ЧЛВК_ИД,ЗДОРОВЬЕ, ОРУЖИЕ, БРОНЯ) values(ИД_З,100,100,100);
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return 0;
End;
$$ language plpgsql;

Create or replace function be_leader(ИД_З int)
Returns int AS $$
DECLARE
	main_worker int := 0;
	second_worker int := 0;
	ask int := 0;
	contract int := 0;
	journal int := 0;
	result_id int := 0;
BEGIN
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента')) then
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into main_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Отдел менеджмента');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = main_worker;

	INSERT INTO ЗАЯВКА(ЧЛВК_ИД, ТИП_ЗАПРОСА, СТАТУС_ОДОБРЕНИЯ) values(ИД_З, (Select ИД from ТИП_ЗАПРОСА where РАСШИФРОВКА='Стать предводителем'), (SELECT ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ='ОБРАБАТЫВАЕТСЯ')) returning ИД into ask;

	
	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Финансовый отдел')) then
		update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОТКЛОНЕНО') where ИД = ask;
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, повторите попытку позже';
		return -1;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Финансовый отдел');
	update РАБОТНИК set ЗАНЯТОСТЬ=true where ЧЛВК_ИД = second_worker;

	Update ЧЕЛОВЕК set БАЛАНС = (select БАЛАНС from ЧЕЛОВЕК where ИД=ИД_З)+(select СТОИМОСТЬ from СТОИМОСТЬ where НАЗВАНИЕ = 'Стать предводителем') where ИД=ИД_З;
	update ЗАЯВКА set СТАТУС_ОДОБРЕНИЯ=(select ИД from СТАТУС_ЗАЯВКИ where ОПИСАНИЕ = 'ОДОБРЕНО') where ИД=ask;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	insert into КОНТРАКТ(ЗАЯВКА_ИД, СТАТУС_ВЫПОЛНЕНИЯ) values (ask, (select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЯЕТСЯ')) returning ИД into contract;
	Insert into ВЕДОМОСТЬ(КОНТРАКТ, ОТДЕЛ, ДАТА_ЗАПРОСА) values(contract, (SELECT ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел'),current_date) Returning ИД into journal;

	if not exists(select * from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ = 'Военный отдел')) then
		update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
		raise notice 'Нет свободных сотрудников, операция скоро будет произведена';
		return -2;
	end if;
	select ЧЛВК_ИД into second_worker from РАБОТНИК where ЗАНЯТОСТЬ=false and ОТДЕЛ_ИД=(select ИД from ОТДЕЛ where НАЗВАНИЕ='Военный отдел');

	insert into ВОИН(ЧЛВК_ИД,ЗДОРОВЬЕ, ОРУЖИЕ, БРОНЯ) values(ИД_З,100,100,100);
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = second_worker;
	update ВЕДОМОСТЬ set ДАТА_ВЫПОЛНЕНИЯ=current_date where ИД=journal;
	update КОНТРАКТ set СТАТУС_ВЫПОЛНЕНИЯ=(select ИД from СТАТУС_КОНТРАКТА where ОПИСАНИЕ = 'ВЫПОЛНЕН') where ИД=contract;
	update РАБОТНИК set ЗАНЯТОСТЬ=false where ЧЛВК_ИД = main_worker;
	return 0;
End;
$$ language plpgsql;
