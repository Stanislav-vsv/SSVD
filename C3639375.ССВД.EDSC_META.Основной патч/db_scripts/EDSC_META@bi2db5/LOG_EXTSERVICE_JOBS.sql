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

COMMENT ON TABLE LOG_EXTSERVICE_JOBS IS '������ ���������� �������������� ������� �������� ������ (������� ETL)';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.JOB_ID IS '���������� ������������� �������';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.WORKFLOWRUN_ID IS '���������� ������������� ������� ������ Informatica Power Center';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.FOLDER_NAME IS '��� ����� IPC';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.WORKFLOW_NAME IS '��� ������ IPC';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.START_DTTM IS '���� � ����� ������� ������� ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.END_DTTM IS '���� � ����� ���������� ������ ������� ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.JOBEXECUTE_RESULT IS 'C����� ���������� ������� ETL';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICE_CODE IS '��� �������';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICESESSION_ID IS '������������� ������ �������, ������������ � �������� ���������.';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTSERVICEAUTH_RESULT IS '��������� �������������� � �������� �������';

COMMENT ON COLUMN LOG_EXTSERVICE_JOBS.EXTPROVIDER_CODE IS '��� ����������, � �������� ���� ���������.';

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