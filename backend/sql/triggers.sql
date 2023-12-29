create or replace function non_upd_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ %', new.ИД;
      update ЧЕЛОВЕК set ИМЯ=old.ИМЯ where ИД=new.ИД;
    end if;
	if NEW.ФАМИЛИЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ФАМИЛИИ';
      update ЧЕЛОВЕК set ФАМИЛИЯ=old.ФАМИЛИЯ where ИД=new.ИД;
    end if;  
    return NEW;
  end;
$$ language plpgsql;

create or replace trigger nameUpdCheck after update on ЧЕЛОВЕК for each row execute procedure non_upd_number();

create or replace function non_upd_girl()
returns trigger as $$
	begin
		if not new.ПОЛ=old.ПОЛ then
			raise notice 'Нельзя менять пол';
			update ЧЕЛОВЕК set ПОЛ=old.ПОЛ where ИД=new.ИД;
		end if;
		return new;
	end;
$$ language plpgsql;

create trigger woman_upd_fighter after update on ЧЕЛОВЕК for each row execute procedure non_upd_girl();

create or replace function predv_upd_status()
 returns trigger as $$
	begin
		if exists(select * from ВОИН where ИД_ПРЕДВОДИТЕЛЯ=
				 (select ИД from ВОИН where ЧЛВК_ИД=new.ИД)) and new.СТАТУС_ИД<5 then
			raise notice 'нельзя менять статус этого человека, пока он является предводителем';
 			delete from ВОИН where ИД=new.ИД;
		end if;
		return new;
	end;
$$ language plpgsql;

 create or replace trigger warrior_upd_com after update on ЧЕЛОВЕК for each row execute procedure predv_upd_status();

create or replace function magic_upd_ability()
returns trigger as $$
	begin
		if (select ТИП_ОРУЖИЯ from ХАРАКТЕРИСТИКИ_ОРУЖИЯ where ИД=(select ОРУЖИЕ from ВОИН where ИД=new.ИД_ВОИНА))
			not similar to 'Посох %' then
			raise notice 'Этот воин не умеет использовать магию';
			update ВОИН_ЗАКЛИНАНИЕ set ИД_ВОИНА=old.ИД_ВОИНА|ИД_ЗАКЛИНАНИЯ=old.ИД_ЗАКЛИНАНИЯ where ИД=new.ИД;
		end if;
		return new;
	end;
$$ language plpgsql;

create trigger magic_upd_useful after update on ВОИН_ЗАКЛИНАНИЕ for each row execute procedure magic_upd_ability();

create or replace function normal_upd_level()
returns trigger as $$
begin
	if new.УРОВЕНЬ_ДОСТУПА>5 then
		raise notice 'Превышен максимальный уровень доступа';
		update ТИП_ЗАПРОСА set УРОВЕНЬ_ДОСТУПА=old.УРОВЕНЬ_ДОСТУПА where ИД=new.ИД;
	elseif new.УРОВЕНЬ_ДОСТУПА<1 then
		raise notice 'Уровень доступа меньше минимального';
		update ТИП_ЗАПРОСА set УРОВЕНЬ_ДОСТУПА=old.УРОВЕНЬ_ДОСТУПА where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger level_upd_check after update on ТИП_ЗАПРОСА for each row execute procedure normal_upd_level();

create or replace function normal_upd_group_level()
returns trigger as $$
begin
	if new.УРОВЕНЬ_ПРИВЕЛЕГИЙ>5 then
		raise notice 'Превышен максимальный уровень доступа';
		update ГРУППА set УРОВЕНЬ_ПРИВЕЛЕГИЙ=old.УРОВЕНЬ_ПРИВЕЛЕГИЙ where ИД=new.ИД;
	elseif new.УРОВЕНЬ_ПРИВЕЛЕГИЙ<1 then
		raise notice 'Уровень доступа меньше минимального';
		update ГРУППА set УРОВЕНЬ_ПРИВЕЛЕГИЙ=old.УРОВЕНЬ_ПРИВЕЛЕГИЙ where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger level_upd_group_check after update on ГРУППА for each row execute procedure normal_upd_group_level();

create or replace function time_upd_checker()
returns trigger as $$
begin
	if new.ДАТА_ЗАПРОСА>new.ДАТА_ИСПОЛНЕНИЯ then
		raise notice 'ошибка дат';
		update ВЕДОМОСТИ set ДАТА_ИСПОЛНЕНИЯ=null where ИД=new.ИД;
	end if;
	return new;
end;
$$ language plpgsql;

create or replace trigger time_upd_check after update on ВЕДОМОСТЬ for each row execute procedure time_upd_checker();

