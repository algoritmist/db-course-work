create table ХАРАКТЕРИСТИКИ_ОРУЖИЯ(
  ИД serial primary key,
  ТИП_ОРУЖИЯ varchar,
  УРОН int,
  ТИП_УРОНА varchar
);

create table ХАРАКТЕРИСТИКИ_БРОНИ(
  ИД serial primary key,
  ТИП_БРОНИ varchar,
  ЗАЩИТА int,
  ТИП_ЗАЩИТЫ varchar
);

create table ТИП_ВОИНА(
  ИД serial primary key,
  ТИП varchar,
  БОНУС_К_ОРУЖИЮ int,
  БОНУС_К_БРОНЕ int,
  БОНУС_К_МАГИИ int
);

create table ТИП_ЭФФЕКТА(
  ИД serial primary key,
  описание varchar
);

create table ЗАКЛИНАНИЕ(
  ИД serial primary key,
  ЗАКЛИНАНИЕ varchar,
  УРОН int,
  ЭФФЕКТ int references ТИП_ЭФФЕКТА(ИД) on delete cascade
);

create table МЕСТОПОЛОЖЕНИЕ(
  ИД serial primary key,
  СТРАНА varchar,
  ГОРОД varchar
);

create table СТАТУС(
  ИД serial primary key,
  НОМЕР_СТАТУСА integer,
  РАСШИФРОВКА varchar
);

create table ТИП_ОТДЕЛА(
  ИД serial primary key,
  НАЗВАНИЕ varchar,
  РАСШИФРОВКА varchar
);

create table ОТДЕЛ(
  ИД serial primary key,
  ТИП_ОТДЕЛА int references ТИП_ОТДЕЛА(ИД) on delete cascade
);

create table ГРУППА(
  ИД serial primary key,
  УРОВЕНЬ_ПРИВЕЛЕГИЙ integer,
  ОТДЕЛ int references ОТДЕЛ(ИД) on delete cascade
);

create table ЧЕЛОВЕК(
  ИД serial primary key,
  ИМЯ varchar,
  ФАМИЛИЯ varchar,
  ПОЛ varchar,
  СТАТУС_ИД integer references СТАТУС(ИД) on delete cascade,
  ИД_ГРУППЫ int references ГРУППА(ИД) on delete cascade,
  МЕСТОПОЛОЖЕНИЕ integer references МЕСТОПОЛОЖЕНИЕ(ИД) on delete cascade
);

create table ВОИН(
  ИД serial primary key,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade,
  ИП_ВОИНА int references ТИП_ВОИНА(ИД) on delete cascade,
  ИД_ПРЕДВОДИТЕЛЯ integer references ВОИН(ИД) on delete cascade,
  ЗДОРОВЬЕ integer,
  БРОНЯ int references ХАРАКТЕРИСТИКИ_БРОНИ(ИД) on delete cascade,
  ОРУЖИЕ int references ХАРАКТЕРИСТИКИ_ОРУЖИЯ(ИД) on delete cascade
);

create table ВОИН_ЗАКЛИНАНИЕ(
  ИД serial primary key,
  ИД_ВОИНА int references ВОИН(ИД) on delete cascade,
  ИД_ЗАКЛИНАНИЯ int references ЗАКЛИНАНИЕ(ИД) on delete cascade
);

create table ПРЕДМЕТ(
  ИД serial primary key,
  НАЗВАНИЕ varchar,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade
);

create table ТИП_ЗАПРОСА(
  ИД serial primary key,
  ТИП integer,
  РАСШИФРОВКА varchar,
  УРОВЕНЬ_ДОСТУПА integer
);

create table ЗАЯВКА(
  ИД serial primary key,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade,
  ТИП_ЗАПРОСА int references ТИП_ЗАПРОСА(ИД) on delete cascade,
  БАЛАНС integer,
  СТАТУС_ОДОБРЕНИЯ varchar
);

create table КОНТРАКТ(
  ИД serial primary key,
  НОМЕР_ЗАЯВКИ int references ЗАЯВКА(ИД) on delete cascade,
  СТАТУС_ВЫПОЛНЕНИЯ varchar
);

create table ВЕДОМОСТЬ(
  ИД serial primary key,
  КОНТРАКТ int references КОНТРАКТ(ИД) on delete cascade,
  ПРИМЕЧАНИЕ varchar,
  ОТДЕЛ int references ОТДЕЛ(ИД) on delete cascade,
  ДАТА_ЗАПРОСА timestamp,
  ДАТА_ВЫПОЛНЕНИЯ timestamp
);
