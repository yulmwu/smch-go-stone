-- Sequences
create sequence account_seq start with 1 increment by 1 minvalue 1 nocycle;
create sequence chat_seq start with 1 increment by 1 minvalue 1 nocycle;

-- Tables
create table account (
    account_num number(20) primary key,
    id varchar2(100) not null,
    password varchar2(100) not null,
    realname varchar2(100) not null,
    nickname varchar2(100) not null,
    email varchar2(100) not null
);

create table chat (
    chat_num number(20) primary key,
    id varchar2(100) not null,
    nickname varchar2(100) not null,
    chat_time varchar2(100) not null,
    chat_text varchar2(100) not null
);

