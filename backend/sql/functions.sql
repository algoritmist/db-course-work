create or replace function non_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ %', new.ИД;
      DELETE FROM ЧЕЛОВЕК where ИМЯ=new.ИМЯ;
    elseif NEW.ФАМИЛИЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ФАМИЛИИ';
      DELETE FROM ЧЕЛОВЕК where ФАМИЛИЯ=NEW.ФАМИЛИЯ;
    end if;  
    return NEW;
  end;
$$ language plpgsql;

create or replace function non_girl()
returns trigger as $$
	begin
		if exists(select * from ЧЕЛОВЕК where ИД=new.ЧЛВК_ИД and ПОЛ='ж') then
			raise notice 'Женщина не может стать воином';
			delete from ВОИН where ИД=new.ИД;
		end if;
		return new;
	end;
$$ language plpgsql;

create or replace function predv_status()
 returns trigger as $$
	begin
		if 5>any(select НОМЕР_СТАТУСА from ЧЕЛОВЕК 
			   join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where ЧЕЛОВЕК.ИД=
 			   (select (ЧЛВК_ИД) from ВОИН where ИД=new.ИД_ПРЕДВОДИТЕЛЯ)) then
			raise notice 'этот воин не может стать предводителем из-за маленького ранга';
 			delete from ВОИН where ИД=new.ИД;
		end if;
		return new;
	end;
-$$ language plpgsql;

create or replace function magic_ability()
returns trigger as $$
	begin
		if (select ТИП_ОРУЖИЯ from ХАРАКТЕРИСТИКИ_ОРУЖИЯ where ИД=(select ОРУЖИЕ from ВОИН where ИД=new.ИД_ВОИНА))
			not similar to 'Посох %' then
			raise notice 'Этот воин не умеет использовать магию';
			delete from ВОИН_ЗАКЛИНАНИЕ where ИД=new.ИД;
		end if;
		return new;
	end;
$$ language plpgsql;

create or replace function normal_level()
returns trigger as $$
begin
	if new.УРОВЕНЬ_ДОСТУПА>5 then
		raise notice 'Превышен максимальный уровень доступа';
		delete from ТИП_ЗАПРОСА where ИД=new.ИД;
	elseif new.УРОВЕНЬ_ДОСТУПА<1 then
		raise notice 'Уровень доступа меньше минимального';
		delete from ТИП_ЗАПРОСА where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace function normal_group_level()
returns trigger as $$
begin
	if new.УРОВЕНЬ_ПРИВЕЛЕГИЙ>5 then
		raise notice 'Превышен максимальный уровень доступа';
		delete from ГРУППА where ИД=new.ИД;
	elseif new.УРОВЕНЬ_ПРИВЕЛЕГИЙ<1 then
		raise notice 'Уровень доступа меньше минимального';
		delete from ГРУППА where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace function time_checker()
returns trigger as $$
begin
	if new.ДАТА_ЗАПРОСА>new.ДАТА_ИСПОЛНЕНИЯ then
		raise notice 'ошибка дат';
		delete from ВЕДОМОСТЬ where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

