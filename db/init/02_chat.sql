-- Chat table and sequence
CREATE TABLE chat (
  no         NUMBER        PRIMARY KEY,
  id         VARCHAR2(20)  NOT NULL,
  nickname   VARCHAR2(10)  NOT NULL,
  chat_time  VARCHAR2(40)  NOT NULL,
  chat_text  VARCHAR2(4000) NOT NULL
);

CREATE SEQUENCE chat_seq START WITH 1 INCREMENT BY 1 NOCACHE;

