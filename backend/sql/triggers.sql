<<<<<<< HEAD
create or replace function non_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ';
      DELETE FROM ЧЕЛОВЕК where ИМЯ=new.ИМЯ;
    elseif NEW.ФАМИЛИЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ФАМИЛИИ';
      DELETE FROM ЧЕЛОВЕК where ФАМИЛИЯ=NEW.ФАМИЛИЯ;
    end if;
    return NEW;
  end;
$$ language plpgsql;

create trigger nameCheck after insert on ЧЕЛОВЕК for each row execute procedure non_number();


create or replace function non_girl()
returns trigger as $$
        begin
                if exists(select * from ЧЕЛОВЕК where ИД=new.ЧЛВК_ИД and ПОЛ='Ж') then
                        raise notice 'Женщина не может стать воином';
                        delete from ВОИН where ИД=new.ИД;
                end if;
                return new;
        end;
$$ language plpgsql;

create trigger woman_fighter after insert on ВОИН for each row execute procedure non_girl();


create or replace function predv_status()
 returns trigger as $$
        begin
                if 3=any(select НОМЕР_СТАТУСА from ЧЕЛОВЕК
                           join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where ЧЕЛОВЕК.ИД=
                           (select (ЧЛВК_ИД) from ВОИН where ИД=new.ПРЕДВОДИТЕЛЬ_ИД)) or 2=any(select НОМЕР_СТАТУСА from ЧЕЛОВЕК
                           join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where ЧЕЛОВЕК.ИД=
                           (select (ЧЛВК_ИД) from ВОИН where ИД=new.ПРЕДВОДИТЕЛЬ_ИД)) then
                        raise notice 'этот воин не может стать предводителем из-за маленького ранга';
                        delete from ВОИН where ИД=new.ИД;
                end if;
                return new;
        end;
$$ language plpgsql;

create or replace trigger warrior_com after insert on ВОИН for each row execute procedure predv_status();


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

create or replace trigger time_check after insert on ВЕДОМОСТЬ for each row execute procedure time_checker();


create or replace function non_upd_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ';
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
                if exists(select * from ВОИН where ПРЕДВОДИТЕЛЬ_ИД=
                                 (select ИД from ВОИН where ЧЛВК_ИД=new.ИД)) and new.СТАТУС_ИД<>2 and new.СТАТУС_ИД<>3 then
                        raise notice 'нельзя менять статус этого человека, пока он является предводителем';
                        delete from ВОИН where ИД=new.ИД;
                end if;
                return new;
        end;
$$ language plpgsql;

 create or replace trigger warrior_upd_com after update on ЧЕЛОВЕК for each row execute procedure predv_upd_status();
=======

create or replace function non_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ';
      DELETE FROM ЧЕЛОВЕК where ИМЯ=new.ИМЯ;
    elseif NEW.ФАМИЛИЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ФАМИЛИИ';
      DELETE FROM ЧЕЛОВЕК where ФАМИЛИЯ=NEW.ФАМИЛИЯ;
    end if;
    return NEW;
  end;
$$ language plpgsql;

create trigger nameCheck after insert on ЧЕЛОВЕК for each row execute procedure non_number();


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

create trigger woman_fighter after insert on ВОИН for each row execute procedure non_girl();


create or replace function predv_status()
 returns trigger as $$
        begin
                if 3=any(select НОМЕР_СТАТУСА from ЧЕЛОВЕК
                           join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where ЧЕЛОВЕК.ИД=
                           (select (ЧЛВК_ИД) from ВОИН where ИД=new.ИД_ПРЕДВОДИТЕЛЯ)) or 2=any(select НОМЕР_СТАТУСА from ЧЕЛОВЕК
                           join СТАТУС on ЧЕЛОВЕК.СТАТУС_ИД=СТАТУС.ИД where ЧЕЛОВЕК.ИД=
                           (select (ЧЛВК_ИД) from ВОИН where ИД=new.ИД_ПРЕДВОДИТЕЛЯ)) then
                        raise notice 'этот воин не может стать предводителем из-за маленького ранга';
                        delete from ВОИН where ИД=new.ИД;
                end if;
                return new;
        end;
$$ language plpgsql;

create or replace trigger warrior_com after insert on ВОИН for each row execute procedure predv_status();


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

create or replace trigger time_check after insert on ВЕДОМОСТЬ for each row execute procedure time_checker();


create or replace function non_upd_number()
returns trigger as $$
  begin
    if NEW.ИМЯ similar to '%[0-9]+%' THEN
      RAISE NOTICE 'НЕПРАВИЛЬНЫЙ ВВОД ИМЕНИ';
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
                                 (select ИД from ВОИН where ЧЛВК_ИД=new.ИД)) and new.СТАТУС_ИД<>2 and new.СТАТУС_ИД<>3 then
                        raise notice 'нельзя менять статус этого человека, пока он является предводителем';
                        delete from ВОИН where ИД=new.ИД;
                end if;
                return new;
        end;
$$ language plpgsql;

 create or replace trigger warrior_upd_com after update on ЧЕЛОВЕК for each row execute procedure predv_upd_status();
>>>>>>> origin/pupyr/dev/create
