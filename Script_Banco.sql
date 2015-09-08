/******************************************************************************/
/***                                 Database                               ***/
/******************************************************************************/

-- Database: timetracking

-- DROP DATABASE timetracking;

CREATE DATABASE timetracking
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'C'
       LC_CTYPE = 'C'
       CONNECTION LIMIT = -1;
GRANT ALL ON DATABASE timetracking TO public;
GRANT ALL ON DATABASE timetracking TO postgres;

/******************************************************************************/
/***                                 Tables                                 ***/
/******************************************************************************/

CREATE TABLE EVENTO (
    I_COD_EVENTO  BIGINT NOT NULL,
    I_COD_TAREFA  BIGINT NOT NULL,
    I_COD_TIPO    BIGINT,
    DT_INI        TIMESTAMP,
    DT_FIN        TIMESTAMP,
    HR_TEMPO      TIME,
    S_OBS_PARADA  VARCHAR(100)
);


CREATE TABLE SITUACAO (
    I_COD_SITUACAO  BIGINT NOT NULL,
    S_NOME          VARCHAR(50)
);


CREATE TABLE TAREFAS (
    I_COD_TAREFA      BIGINT NOT NULL,
	I_COD_SITUACAO    BIGINT NOT NULL,
	I_COD_USUARIO     BIGINT,
    S_NOME            VARCHAR(255),
    S_DESCRICAO       VARCHAR(255),
    DT_INI            DATE,
    I_ESTIMATIVA      INTEGER,
    I_REALIZADO       INTEGER,
    I_PERC_CONCLUSAO  INTEGER,
    S_VERSAO          VARCHAR(10)
);


CREATE TABLE TIPO (
    I_COD_TIPO  BIGINT NOT NULL,
    S_NOME      VARCHAR(50)
);


CREATE TABLE USUARIOS (
    I_COD_USUARIO  BIGINT NOT NULL,
    S_NOME         VARCHAR(50),
    S_USUARIO      VARCHAR(10),
    S_SENHA        VARCHAR(10)
);

/******************************************************************************/
/***                              Primary Keys                              ***/
/******************************************************************************/

ALTER TABLE EVENTO ADD CONSTRAINT PK_EVENTO PRIMARY KEY (I_COD_EVENTO);
ALTER TABLE SITUACAO ADD CONSTRAINT PK_SITUACAO PRIMARY KEY (I_COD_SITUACAO);
ALTER TABLE TAREFAS ADD CONSTRAINT PK_TAREFAS PRIMARY KEY (I_COD_TAREFA);
ALTER TABLE TIPO ADD CONSTRAINT PK_TIPO PRIMARY KEY (I_COD_TIPO);
ALTER TABLE USUARIOS ADD CONSTRAINT PK_USUARIOS PRIMARY KEY (I_COD_USUARIO);

/******************************************************************************/
/***                              Foreign Keys                              ***/
/******************************************************************************/

ALTER TABLE EVENTO ADD CONSTRAINT FK_EVENTO_1 FOREIGN KEY (I_COD_TAREFA) REFERENCES TAREFAS (I_COD_TAREFA);
ALTER TABLE EVENTO ADD CONSTRAINT FK_EVENTO_2 FOREIGN KEY (I_COD_TIPO) REFERENCES TIPO (I_COD_TIPO);
ALTER TABLE TAREFAS ADD CONSTRAINT FK_TAREFAS_1 FOREIGN KEY (I_COD_USUARIO) REFERENCES USUARIOS (I_COD_USUARIO);
ALTER TABLE TAREFAS ADD CONSTRAINT FK_TAREFAS_2 FOREIGN KEY (I_COD_SITUACAO) REFERENCES SITUACAO (I_COD_SITUACAO);

/******************************************************************************/
/***                              Sequences                                 ***/
/******************************************************************************/

CREATE SEQUENCE seq_evento
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 999999999999999999
  START 1
  CACHE 1;
  
CREATE SEQUENCE seq_situacao
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 999999999999999999
  START 1
  CACHE 1;
  
CREATE SEQUENCE seq_tarefas
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 999999999999999999
  START 1
  CACHE 1;
  
CREATE SEQUENCE seq_tipo
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 999999999999999999
  START 1
  CACHE 1;
  
CREATE SEQUENCE seq_usuarios
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 999999999999999999
  START 1
  CACHE 1;