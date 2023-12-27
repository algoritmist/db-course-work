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
  ЭФФЕКТ int references ТИП_ЭФФЕКТА(ИД)
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
  ТИП_ОТДЕЛА int references ТИП_ОТДЕЛА(ИД)
);

create table ГРУППА(
  ИД serial primary key,
  УРОВЕНЬ_ПРИВЕЛЕГИЙ integer,
  ОТДЕЛ int references ОТДЕЛ(ИД)
);

create table ЧЕЛОВЕК(
  ИД serial primary key,
  ИМЯ varchar,
  ФАМИЛИЯ varchar,
  ПОЛ varchar,
  СТАТУС_ИД integer references СТАТУС(ИД),
  ИД_ГРУППЫ int references ГРУППА(ИД),
  МЕСТОПОЛОЖЕНИЕ integer references МЕСТОПОЛОЖЕНИЕ(ИД)
);

create table ВОИН(
  ИД serial primary key,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД),
  ИП_ВОИНА int references ТИП_ВОИНА(ИД),
  ИД_ПРЕДВОДИТЕЛЯ integer references ВОИН(ИД),
  ЗДОРОВЬЕ integer,
  БРОНЯ int references ХАРАКТЕРИСТИКИ_БРОНИ(ИД),
  ОРУЖИЕ int references ХАРАКТЕРИСТИКИ_ОРУЖИЯ(ИД)
);

create table ВОИН_ЗАКЛИНАНИЕ(
  ИД serial primary key,
  ИД_ВОИНА int references ВОИН(ИД),
  ИД_ЗАКЛИНАНИЯ int references ЗАКЛИНАНИЕ(ИД)
);

create table ПРЕДМЕТ(
  ИД serial primary key,
  НАЗВАНИЕ varchar,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД)
);

create table ТИП_ЗАПРОСА(
  ИД serial primary key,
  ТИП integer,
  РАСШИФРОВКА varchar,
  УРОВЕНЬ_ДОСТУПА integer
);

create table ЗАЯВКА(
  ИД serial primary key,
  ЧЛВК_ИД int references ЧЕЛОВЕК(ИД),
  ТИП_ЗАПРОСА int references ТИП_ЗАПРОСА(ИД),
  БАЛАНС integer,
  СТАТУС_ОДОБРЕНИЯ varchar
);

create table КОНТРАКТ(
  ИД serial primary key,
  НОМЕР_ЗАЯВКИ int references ЗАЯВКА(ИД),
  СТАТУС_ВЫПОЛНЕНИЯ varchar
);

create table ВЕДОМОСТЬ(
  ИД serial primary key,
  КОНТРАКТ int references КОНТРАКТ(ИД),
  ПРИМЕЧАНИЕ varchar,
  ОТДЕЛ int references ОТДЕЛ(ИД),
  ДАТА_ЗАПРОСА timestamp,
  ДАТА_ВЫПОЛНЕНИЯ timestamp
);