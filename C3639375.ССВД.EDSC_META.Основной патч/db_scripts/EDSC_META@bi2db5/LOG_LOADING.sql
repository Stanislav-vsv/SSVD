begin
execute immediate 'drop table LOG_LOADING CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE LOG_LOADING
(
  LOADING_ID      NUMBER(38)                    NOT NULL,
  FOLDER_NAME     VARCHAR2(128 BYTE)            NOT NULL,
  WORKFLOW_NAME   VARCHAR2(128 BYTE)            NOT NULL,
  WORKFLOWRUN_ID  NUMBER(38)                    NOT NULL,
  START_DTTM      DATE                          NOT NULL,
  END_DTTM        DATE,
  REG_LOADING_ID  NUMBER(38),
  STATUS_CODE     VARCHAR2(100 BYTE)
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

COMMENT ON TABLE LOG_LOADING IS '������ ������ ����������� � ������������ �������';

COMMENT ON COLUMN LOG_LOADING.LOADING_ID IS '���������� ������������� ���������� ��������������� ������';

COMMENT ON COLUMN LOG_LOADING.FOLDER_NAME IS '���������� ��� ����� IPC';

COMMENT ON COLUMN LOG_LOADING.WORKFLOW_NAME IS '���������� ��� ������ IPC.';

COMMENT ON COLUMN LOG_LOADING.WORKFLOWRUN_ID IS '������������� ���������� ������, ������������ IPC';

COMMENT ON COLUMN LOG_LOADING.START_DTTM IS '���� � ����� ������� ������';

COMMENT ON COLUMN LOG_LOADING.END_DTTM IS '���� � ����� ���������� ������ ������';

COMMENT ON COLUMN LOG_LOADING.REG_LOADING_ID IS '���������� ������������ ������ �� ������� �������� ������������� ������. ����������� ������ ��� ����������� �������';

COMMENT ON COLUMN LOG_LOADING.STATUS_CODE IS '������� ������ ���������� ������������/������������� ������.';

CREATE UNIQUE INDEX LOG_LOADING_PK ON LOG_LOADING
(LOADING_ID)
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
ALTER TABLE LOG_LOADING ADD (
  CONSTRAINT LOG_LOADING_PK
  PRIMARY KEY
  (LOADING_ID)
  USING INDEX LOG_LOADING_PK
  ENABLE VALIDATE);