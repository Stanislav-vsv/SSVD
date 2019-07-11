begin
execute immediate 'drop table LOG_SQL CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE LOG_SQL
(
  FOLDER_NAME       VARCHAR2(128 BYTE),
  WORKFLOW_NAME     VARCHAR2(128 BYTE),
  PROC_NAME         VARCHAR2(128 BYTE),
  TARGETTABLE_NAME  VARCHAR2(128 BYTE),
  SOURCETABLE_NAME  VARCHAR2(128 BYTE),
  SOURCE_CODE       VARCHAR2(4000 BYTE),
  JOB_ID            NUMBER(38),
  START_DTTM        DATE,
  END_DTTM          DATE,
  ROWS_CNT          NUMBER(38),
  SQLERRM_TEXT      VARCHAR2(4000 BYTE),
  SYSTIME_TMST      TIMESTAMP(6),
  OSUSER_CODE       VARCHAR2(128 BYTE),
  SESSIONUSER_CODE  VARCHAR2(128 BYTE),
  MESSAGE_TEXT      VARCHAR2(4000 BYTE),
  SQL_TEXT          CLOB
)
TABLESPACE EDSC_META
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCOMPRESS ;

COMMENT ON TABLE LOG_SQL IS 'Журнал исполнения динамических SQL-запросов';

COMMENT ON COLUMN LOG_SQL.FOLDER_NAME IS 'Имя папки';

COMMENT ON COLUMN LOG_SQL.WORKFLOW_NAME IS 'Имя потока.';

COMMENT ON COLUMN LOG_SQL.PROC_NAME IS 'Имя процедуры';

COMMENT ON COLUMN LOG_SQL.TARGETTABLE_NAME IS 'Имя таблицы-приемника';

COMMENT ON COLUMN LOG_SQL.SOURCETABLE_NAME IS 'Имя таблицы-источника';

COMMENT ON COLUMN LOG_SQL.SOURCE_CODE IS 'Номер источника';

COMMENT ON COLUMN LOG_SQL.JOB_ID IS 'Идентификатор загрузки (уникальный номер загрузки), в рамках которой произошло добавление записи.';

COMMENT ON COLUMN LOG_SQL.START_DTTM IS 'Дата начала загрузки.';

COMMENT ON COLUMN LOG_SQL.END_DTTM IS 'Дата окончания загрузки.';

COMMENT ON COLUMN LOG_SQL.ROWS_CNT IS 'Количество строк';

COMMENT ON COLUMN LOG_SQL.SQLERRM_TEXT IS 'Тип ошибки';

COMMENT ON COLUMN LOG_SQL.SYSTIME_TMST IS 'Дата актуализации';

COMMENT ON COLUMN LOG_SQL.OSUSER_CODE IS 'Логин пользователя ОС,  с рабочей станции сервера которого осуществляется подключение к БД.';

COMMENT ON COLUMN LOG_SQL.SESSIONUSER_CODE IS 'Логин пользователя БД, под которым осуществляется подключение.';

COMMENT ON COLUMN LOG_SQL.MESSAGE_TEXT IS 'Сообщение';

COMMENT ON COLUMN LOG_SQL.SQL_TEXT IS 'Текст SQL';