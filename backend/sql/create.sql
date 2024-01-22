create table СТАТУС
(
    ИД       serial primary key,
    НОМЕР_СТАТУСА int not null,
    НАЗВАНИЕ varchar not null
);

create table МЕСТОПОЛОЖЕНИЕ
(
    ИД      serial primary key,
    СТРАНА  varchar,
    ГОРОД   varchar,
    ШИРОТА  real,
    ДОЛГОТА real
);

create table ЧЕЛОВЕК
(
    ИД            serial primary key,
    ИМЯ           varchar not null,
    ФАМИЛИЯ       varchar not null,
    ПОЛ           varchar check (ПОЛ = 'М' or ПОЛ = 'Ж'),
    ДАТА_РОЖДЕНИЯ timestamp,
    СТАТУС_ИД     int references СТАТУС (ИД) on delete cascade,
    БАЛАНС        int     not null,
    ПРОДАЖА_ДУШИ  bool,
    МЕСТОПОЛОЖЕНИЕ int references МЕСТОПОЛОЖЕНИЕ (ИД) on delete cascade
);

create table ТИП_ВОИНА
(
    ТИП           varchar primary key,
    АТАКА         int,
    ЗАЩИТА        int,
    БОНУС_К_МАГИИ int
);

create table ВОИН
(
    ЧЛВК_ИД         int primary key references ЧЕЛОВЕК (ИД) on delete cascade,
    ТИП_ВОИНА       varchar references ТИП_ВОИНА (ТИП) on delete cascade,
    ПРЕДВОДИТЕЛЬ_ИД int references ВОИН (ЧЛВК_ИД) on delete cascade,
    ЗДОРОВЬЕ        int not null check ( ЗДОРОВЬЕ >= 0 ),
    БРОНЯ           int not null check ( БРОНЯ >= 0 ),
    ОРУЖИЕ          int not null check ( ОРУЖИЕ >= 0 )
);

create table ПРЕДМЕТ
(
    ИД       serial primary key,
    НАЗВАНИЕ varchar not null,
    ЧЛВК_ИД  int references ЧЕЛОВЕК (ИД) on delete cascade,
    ЦЕНА     int
);

create table ЗАКЛИНАНИЕ
(
    НАЗВАНИЕ varchar primary key,
    УРОН     int     not null
);

create table ЗАКЛИНАНИЯ_ВОИНА
(
    ВОИН_ИД             int references ВОИН (ЧЛВК_ИД) on delete cascade,
    ЗАКЛИНАНИЕ_НАЗВАНИЕ varchar references ЗАКЛИНАНИЕ (НАЗВАНИЕ) on delete cascade,
    PRIMARY KEY (ВОИН_ИД, ЗАКЛИНАНИЕ_НАЗВАНИЕ)
);

create table ТИП_ЗАПРОСА
(
    ИД              serial primary key,
    РАСШИФРОВКА     varchar not null
);


create table ОТДЕЛ
(
    ИД          serial primary key,
    НАЗВАНИЕ    varchar not null,
    РАСШИФРОВКА varchar not null
);

create table РАБОТНИК
(
    ЧЛВК_ИД         int references ЧЕЛОВЕК (ИД) on delete cascade,
    ОТДЕЛ_ИД        int references ОТДЕЛ (ИД) on delete cascade,
    ЗАНЯТОСТЬ       bool
);

create table СТАТУС_ЗАЯВКИ
(
    ИД       serial primary key,
    ОПИСАНИЕ varchar not null
);

create table СТАТУС_КОНТРАКТА
(
    ИД       serial primary key,
    ОПИСАНИЕ varchar not null
);

create table ЗАЯВКА
(
    ИД               serial primary key,
    ЧЛВК_ИД          int references ЧЕЛОВЕК (ИД) on delete cascade,
    ТИП_ЗАПРОСА      int references ТИП_ЗАПРОСА (ИД) on delete cascade,
    ЦЕЛЬ_ЧЛВК_ИД     int references ЧЕЛОВЕК (ИД) on delete cascade,
    ЦЕЛЬ_ПРЕДМЕТ_ИД  int references ПРЕДМЕТ (ИД) on delete cascade,
    СТАТУС_ОДОБРЕНИЯ int references СТАТУС_ЗАЯВКИ (ИД) on delete cascade,
    ТИП_ВОИНА        varchar references ТИП_ВОИНА (ТИП) on delete cascade
);

create table КОНТРАКТ
(
    ИД                serial primary key,
    ЗАЯВКА_ИД         int references ЗАЯВКА (ИД) on delete cascade,
    СТАТУС_ВЫПОЛНЕНИЯ int references СТАТУС_КОНТРАКТА (ИД) on delete cascade
);

create table ВЕДОМОСТЬ
(
    ИД              serial primary key,
    КОНТРАКТ        int references КОНТРАКТ (ИД) on delete cascade,
    ОТДЕЛ           int references ОТДЕЛ (ИД) on delete cascade,
    ДАТА_ЗАПРОСА    timestamp,
    ДАТА_ВЫПОЛНЕНИЯ timestamp,
    МЕСТО_ПРОВЕДЕНИЯ int references МЕСТОПОЛОЖЕНИЕ (ИД) on delete cascade
);

create table СТОИМОСТЬ
(
    НАЗВАНИЕ        varchar primary key,
    СТОИМОСТЬ       int
);