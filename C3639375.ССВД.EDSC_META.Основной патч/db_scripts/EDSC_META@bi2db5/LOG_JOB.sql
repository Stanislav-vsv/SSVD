begin
execute immediate 'drop table LOG_JOB CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE LOG_JOB
(
  JOB_ID          NUMBER(38)                    NOT NULL,
  FOLDER_NAME     VARCHAR2(128 BYTE)            NOT NULL,
  WORKFLOW_NAME   VARCHAR2(128 BYTE)            NOT NULL,
  WORKFLOWRUN_ID  NUMBER(38)                    NOT NULL,
  LOADING_ID      NUMBER(38),
  START_DTTM      DATE                          NOT NULL,
  END_DTTM        DATE,
  STATUS_CODE     VARCHAR2(100 BYTE)
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

COMMENT ON TABLE LOG_JOB IS '������ ������ ����������� � ������������ �������';

COMMENT ON COLUMN LOG_JOB.JOB_ID IS '���������� ������������� ���������� ��������������� ������';

COMMENT ON COLUMN LOG_JOB.FOLDER_NAME IS '���������� ��� ����� IPC';

COMMENT ON COLUMN LOG_JOB.WORKFLOW_NAME IS '���������� ��� ������ IPC.';

COMMENT ON COLUMN LOG_JOB.WORKFLOWRUN_ID IS '������������� ���������� ������, ������������ IPC';

COMMENT ON COLUMN LOG_JOB.LOADING_ID IS '������������� ���������� ������������ ������. ���������� ������ �� ������� LOG_LOADING';

COMMENT ON COLUMN LOG_JOB.START_DTTM IS '���� � ����� ������� ������';

COMMENT ON COLUMN LOG_JOB.END_DTTM IS '���� � ����� ���������� ������ ������';

COMMENT ON COLUMN LOG_JOB.STATUS_CODE IS '������� ������ ���������� ��������������� ������.';


CREATE UNIQUE INDEX LOG_JOB_PK ON LOG_JOB
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


ALTER TABLE LOG_JOB ADD (
  CONSTRAINT LOG_JOB_PK
  PRIMARY KEY
  (JOB_ID)
  USING INDEX LOG_JOB_PK
  ENABLE VALIDATE);

ALTER TABLE LOG_JOB ADD (
  CONSTRAINT LOG_JOB_IPCOBJECT_FK 
  FOREIGN KEY (FOLDER_NAME, WORKFLOW_NAME) 
  REFERENCES MD_IPCOBJECTS (FOLDER_NAME,WORKFLOW_NAME)
  ENABLE VALIDATE,
  CONSTRAINT LOG_JOB_STATUS_FK 
  FOREIGN KEY (STATUS_CODE) 
  REFERENCES DCT_STATUSES (STATUS_CODE)
  ENABLE VALIDATE);
