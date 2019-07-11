begin
execute immediate 'drop table USR_PARAMOVERRIDES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE USR_PARAMOVERRIDES
(
  REG_LOADING_ID     NUMBER(38),
  LOADING_ID         NUMBER(38),
  JOB_ID             NUMBER(38),
  IPCOBJTYPE_CODE    VARCHAR2(128 BYTE)         NOT NULL,
  IPCOBJECT_NAME     VARCHAR2(128 BYTE),
  REG_FOLDER_NAME    VARCHAR2(128 BYTE),
  REG_WORKFLOW_NAME  VARCHAR2(128 BYTE),
  FOLDER_NAME        VARCHAR2(128 BYTE)         NOT NULL,
  WORKFLOW_NAME      VARCHAR2(128 BYTE)         NOT NULL,
  PARAM_NAME         VARCHAR2(128 BYTE)         NOT NULL,
  PARAM_VALUE        VARCHAR2(4000 BYTE),
  CYCLE_ORDER_NO     VARCHAR2(25 BYTE)          DEFAULT 0                     NOT NULL,
  CYCLE_STATUS       VARCHAR2(4000 BYTE)        DEFAULT 'N/A'                 NOT NULL,
  CYCLE_LOADING_ID   NUMBER(38)
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

COMMENT ON TABLE USR_PARAMOVERRIDES IS '��������������� �������� ����������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_LOADING_ID IS '������������� ������� ������������� ������. ��� ������ ������� �� �����������. ����������� � ����������� ������������� � ��������� INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.LOADING_ID IS '������������� ������� ������������ ������. ��� ������ ������� �� �����������. ����������� � ����������� ������������� � ��������� INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.JOB_ID IS '������������� ������� ��������������� ������. ��� ������ ������� �� �����������. ����������� � ����������� ������������� � ��������� INIT JOB';

COMMENT ON COLUMN USR_PARAMOVERRIDES.IPCOBJTYPE_CODE IS '���������� ��� ������� IPC, ��� �������� � ����� ����������. ������ �� ������� DCT_IPCOBJTYPES. ';

COMMENT ON COLUMN USR_PARAMOVERRIDES.IPCOBJECT_NAME IS '��� ������� (������, �������) ��� �������� ����� ����������� ������ � ����� ����������. ';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_FOLDER_NAME IS '����� ������������� ������, � ������ �������� ����� ������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.REG_WORKFLOW_NAME IS '��� ������������� ������, � ������ �������� ����� ������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.FOLDER_NAME IS '����� JOB ��� CTL ��� REG ������, ��� �������� ��������� ���������������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.WORKFLOW_NAME IS '������������ JOB ��� CTL ��� REG ������, ��� �������� ��������� ���������������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.PARAM_NAME IS '������������ ���������, �������� �������� ��������� ��������������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.PARAM_VALUE IS '�������� ���������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_ORDER_NO IS '������� ������������ ������� �������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_STATUS IS '������ ������������ ������� ������';

COMMENT ON COLUMN USR_PARAMOVERRIDES.CYCLE_LOADING_ID IS 'LOADING_ID ������, ������������ ����������� ���������';