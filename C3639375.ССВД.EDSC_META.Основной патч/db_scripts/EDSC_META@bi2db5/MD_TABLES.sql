begin
execute immediate 'drop table MD_TABLES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_TABLES
(
  SCHEMA_NAME  VARCHAR2(30 BYTE)                NOT NULL,
  TABLE_NAME   VARCHAR2(30 BYTE)                NOT NULL,
  TABLE_DESC   VARCHAR2(4000 BYTE)              NOT NULL,
  CHANGE_DATE  DATE                             NOT NULL,
  PATCH_CODE   VARCHAR2(128 BYTE)
)
TABLESPACE EDSC_META
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCOMPRESS ;

COMMENT ON TABLE MD_TABLES IS 'Реестр таблиц Витрины';

COMMENT ON COLUMN MD_TABLES.SCHEMA_NAME IS 'SQL-имя схемы, в которой размещена таблица Витрины';

COMMENT ON COLUMN MD_TABLES.TABLE_NAME IS 'SQL-имя таблицы Витрины';

COMMENT ON COLUMN MD_TABLES.TABLE_DESC IS 'Описание таблицы';

COMMENT ON COLUMN MD_TABLES.CHANGE_DATE IS 'Дата последнего изменения информации о параметре';

COMMENT ON COLUMN MD_TABLES.PATCH_CODE IS 'Номер последнего патча, в котором внесены изменения.';

CREATE UNIQUE INDEX MD_TABLES_PK ON MD_TABLES
(SCHEMA_NAME, TABLE_NAME)
TABLESPACE EDSC_META
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          1M
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );