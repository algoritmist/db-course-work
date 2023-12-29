create trigger nameCheck after insert on ЧЕЛОВЕК for each row execute procedure non_number();

create trigger woman_fighter after insert on ВОИН for each row execute procedure non_girl();

create or replace trigger warrior_com after insert on ВОИН for each row execute procedure predv_status();

create trigger magic_useful after insert on ВОИН_ЗАКЛИНАНИЕ for each row execute procedure magic_ability();
anguage plpgsql;

create or replace trigger level_check after insert on ТИП_ЗАПРОСА for each row execute procedure normal_level();

create or replace trigger level_group_check after insert on ГРУППА for each row execute procedure normal_group_level();

create or replace trigger time_check after insert on ВЕДОМОСТЬ for each row execute procedure time_checker();

