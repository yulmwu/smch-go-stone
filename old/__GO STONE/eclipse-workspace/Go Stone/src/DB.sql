create sequence account_seq
start with 1
increment by 1
minvalue 1
nocycle


create table account (
	account_num number(20) primary key,
	id varchar2(100) not null,
	password varchar2(100) not null,
	realname varchar2(100) not null,
	nickname varchar2(100) not null,
	email varchar2(100) not null
);


insert into ACCOUNT values(account_seq.nextval, 'id', 'password', 'realname', 'nickname', 'email');


select sequence_name from account_seq;

select * from account;

INSERT INTO EX_TABLE(BOARD_NUM) VALUES(USER_SEQ.NEXTVAL);


SELECT user_SEQ.CURRVAL FROM DUAL --해당 시퀀스 값 조회
SELECT * FROM USER_SEQUENCES



select * from ACCOUNT where id='malocsa' and password='1231';
update account set password='qweq' where id='malocsa';

delete account;

drop table account;




drop sequence account_seq;





--채팅--

create sequence chat_seq
start with 1
increment by 1
minvalue 1
nocycle

create table chat (
	-- seq_num, id, nickname, time, chat
	chat_num number(20) primary key,
	id varchar2(100) not null,
	nickname varchar2(100) not null,
	chat_time varchar2(100) not null,
	chat_text varchar2(100) not null
);

select * from chat;

drop table chat;

drop sequence chat_seq;

insert into CHAT values(chat_seq.nextval, 'id', 'nickname', 'chat_time', 'chat_text');


