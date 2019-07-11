begin
execute immediate 'drop table LOG_EXTSERVICE_JOBS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE LOG_EXTSERVICE_JOBS
(
  JOB_ID                 NUMBER(38)             NOT NULL,
  WORKFLOWRUN_ID         NUMBER(38)             NOT NULL,
  FOLDER_NAME            VARCHAR2(100 BYTE),
  WORKFLOW_NAME          VARCHAR2(100 BYTE),
  START_DTTM             DATE,
  END_DTTM               DATE,
  JOBEXECUTE_RESULT      VARCHAR2(100 BYTE),
  EXTSERVICESESSION_ID   VARCHAR2(255 BYTE),
  EXTSERVICEAUTH_RESULT  VARCHAR2(128 BYTE),
  EXTPROVIDER_CODE       VARCHAR2(128 BYTE),
  EXTSERVICE_CODE        VARCHAR2(255 BYTE)
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

COMMENT ON TABLE LOG_EXTSERVICE_JOBS IS 'Журнал исполнения функциональных потоков загрузки данных (функций ETL)';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.JOB_ID IS 'Уникальный идентификатор запуска';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.WORKFLOWRUN_ID IS 'Уникальный идентификатор запуска потока Informatica Power Center';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.FOLDER_NAME IS 'Имя папки IPC';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.WORKFLOW_NAME IS 'Имя потока IPC';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.START_DTTM IS 'Дата и время запуска функции ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.END_DTTM IS 'Дата и время завершения работы функции ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.JOBEXECUTE_RESULT IS 'Cтатус исполнения функции ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICE_CODE IS 'Код сервиса';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICESESSION_ID IS 'Идентификатор сессии сервиса, определенный в процессе обращения.';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICEAUTH_RESULT IS 'Результат аутентификации к внешнему сервису';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTPROVIDER_CODE IS 'Код провайдера, к которому было обращение.';

CREATE UNIQUE INDEX LOG_EXTSERVICE_JOBS_PK ON LOG_EXTSERVICE_JOBS
(JOB_ID)
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

ALTER TABLE LOG_EXTSERVICE_JOBS ADD (
  CONSTRAINT LOG_EXTSERVICE_JOBS_PK
  PRIMARY KEY
  (JOB_ID)
  USING INDEX LOG_EXTSERVICE_JOBS_PK
  ENABLE VALIDATE);