create table ТИП_ВОИНА(
  ТИП varchar primary key,
  БОНУС_К_ОРУЖИЮ int,
  БОНУС_К_БРОНЕ int,
  БОНУС_К_МАГИИ int
);

create table ЗАКЛИНАНИЕ(
  ЗАКЛИНАНИЕ varchar primary key,
  ЭФФЕКТ varchar,
  УРОН int
);

create table СТАТУС(
  ИД serial primary key,
  НОМЕР_СТАТУСА integer,
  РАСШИФРОВКА varchar
);

create table ЧЕЛОВЕК(
  ИД serial primary key,
  ИМЯ varchar,
  ФАМИЛИЯ varchar,
  ПОЛ varchar,
  СТАТУС_ИД integer references СТАТУС(ИД) on delete cascade,
  БАЛАНС int
);

create table ВОИН(
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade,
  ТИП_ВОИНА varchar references ТИП_ВОИНА(ТИП) on delete cascade,
  ИД_ПРЕДВОДИТЕЛЯ integer references ВОИН(ЧЛВК_ИД) on delete cascade,
  ЗДОРОВЬЕ integer,
  БРОНЯ int,
  ОРУЖИЕ int
);

create table ПРЕДМЕТ(
  ИД int references ЧЕЛОВЕК(ИД) on delete cascade,
  НАЗВАНИЕ varchar
);

create table ВОИН_ЗАКЛИНАНИЕ(
  ВОИН_ИД int references ВОИН(ЧЛВК_ИД) on delete cascade,
  НАЗВАНИЕ varchar references ЗАКЛИНАНИЕ(Название) on delete cascade,
  ДЛИТЕЛЬНОСТЬ int
  PRIMARY KEY (ВОИН, НАЗВАНИЕ)
);

create table МЕСТОПОЛОЖЕНИЕ(
  ИД int primary key references ЧЕЛОВЕК(ИД) on delete cascade,
  СТРАНА varchar,
  ГОРОД varchar,
  ШИРОТА real,
  ДОЛГОТА real
);

create table ТИП_ЗАПРОСА(
  ИД serial primary key,
  РАСШИФРОВКА varchar,
  УРОВЕНЬ_ДОСТУПА integer
);

create table ПРИВИЛЕГИИ(ИД serial primary key, ОПИСАНИЕ varchar);

create table ОТДЕЛ( ИД serial primary key, НАЗВАНИЕ varchar, РАСШИФРОВКА varchar);

create table РАБОТНИК(ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade, ОТДЕЛ_ИД int references ОТДЕЛ(ИД) on delete cascade, УРОВЕНЬ_ДОСТУПА int references ПРИВИЛЕГИИ(ИД) on delete cascade);

create table СТАТУС_ЗАЯВКИ(ИД serial primary key, ОПИСАНИЕ varchar);

create table СТАТУС_КОНТРАКТА(ИД serial primary key, ОПИСАНИЕ varchar);

create table ЗАЯВКА(ИД serial primary key, ЧЛВК_ИД int references ЧЕЛОВЕК(ИД) on delete cascade, ТИП_ЗАПРОСА int references ТИП_ЗАПРОСА(ИД) on delete cascade, СТАТУС_ОДОБРЕНИЯ int references СТАТУС_ЗАЯВКИ(ИД) on delete cascade);

create table КОНТРАКТ(ИД serial primary key, ЗАЯВКА_ИД int references ЗАЯВКА(ИД) on delete cascade, СТАТУС_ВЫПОЛНЕНИЯ int references СТАТУС_КОНТРАКТА(ИД) on delete cascade);

create table ВЕДОМОСТЬ(
  ИД serial primary key,
  КОНТРАКТ int references КОНТРАКТ(ИД) on delete cascade,
  ПРИМЕЧАНИЕ varchar,
  ОТДЕЛ int references ОТДЕЛ(ИД) on delete cascade,
  ДАТА_ЗАПРОСА timestamp,
  ДАТА_ВЫПОЛНЕНИЯ timestamp
);