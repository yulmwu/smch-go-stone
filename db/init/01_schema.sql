-- Account table and sequence
CREATE TABLE account (
  no        NUMBER       PRIMARY KEY,
  id        VARCHAR2(20) NOT NULL,
  password  VARCHAR2(20) NOT NULL,
  realname  VARCHAR2(50) NOT NULL,
  nickname  VARCHAR2(10) NOT NULL,
  email     VARCHAR2(50) NOT NULL
);

CREATE SEQUENCE account_seq START WITH 1 INCREMENT BY 1 NOCACHE;

