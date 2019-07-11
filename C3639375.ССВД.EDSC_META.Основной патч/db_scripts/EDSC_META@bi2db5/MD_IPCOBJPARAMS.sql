begin
execute immediate 'drop table MD_IPCOBJPARAMS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_IPCOBJPARAMS
(
  FOLDER_NAME          VARCHAR2(128 BYTE)       NOT NULL,
  WORKFLOW_NAME        VARCHAR2(128 BYTE)       NOT NULL,
  IPCOBJTYPE_CODE      VARCHAR2(25 BYTE)        DEFAULT 'WORKFLOW'            NOT NULL,
  IPCOBJECT_NAME       VARCHAR2(128 BYTE),
  PARAM_NAME           VARCHAR2(128 BYTE)       NOT NULL,
  LOADINGMODE_CODE     VARCHAR2(25 BYTE)        NOT NULL,
  REGLAMENTTYPE_CODE   VARCHAR2(25 BYTE)        NOT NULL,
  PARAMVALUETYPE_CODE  VARCHAR2(128 BYTE)       NOT NULL,
  PARAM_VALUE          VARCHAR2(4000 BYTE)      NOT NULL,
  LOGGING_FLAG         CHAR(1 BYTE)             DEFAULT 'N'                   NOT NULL,
  CHANGE_DATE          DATE                     DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE           VARCHAR2(128 BYTE)
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


COMMENT ON TABLE MD_IPCOBJPARAMS IS '��������� � �������� IPC';

COMMENT ON COLUMN MD_IPCOBJPARAMS.FOLDER_NAME IS '��� �����. ������ �� ��������� ���� MD_IPCOBJECTS';

COMMENT ON COLUMN MD_IPCOBJPARAMS.WORKFLOW_NAME IS '��� ������, ��� �������� ����������� �������� ���������. ������ �� ��������� ���� MD_IPCOBJECTS';

COMMENT ON COLUMN MD_IPCOBJPARAMS.IPCOBJTYPE_CODE IS '���������� ��� ������� IPC, ��� �������� � ����� ����������.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.IPCOBJECT_NAME IS '��� ������� (������, �������) ��� �������� ����� ����������� ������ � ����� ����������.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAM_NAME IS '���������� ��� ���������. ������ �� ������� MD_PARAMETERS.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.LOADINGMODE_CODE IS '���������� ����� ��� ������ ������ ����������� �������';

COMMENT ON COLUMN MD_IPCOBJPARAMS.REGLAMENTTYPE_CODE IS '�����������, ��� ������ ���� ����������  ������������ �������� ���������.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAMVALUETYPE_CODE IS '��� �������� ���������. ������ �� ������� DCT_PARAMVALUETYPES. ��������� ��������: (STATIC,DYNAMIC,SQL)';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PARAM_VALUE IS '�������� ���������. ������� ���������� ���������� � ����������� �� ���� ������ ��������� � ������� �������� ���������� �������� ����������.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.LOGGING_FLAG IS '����, ������������ ��������� �������������� �������� ���������� � LOG_PARAMPREVVALUE ��� ���.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.CHANGE_DATE IS '���� ���������� ��������� ���������� � ��������� � ������� IPC.';

COMMENT ON COLUMN MD_IPCOBJPARAMS.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX MD_IPCOBJPARAMS_PK ON MD_IPCOBJPARAMS
(FOLDER_NAME, WORKFLOW_NAME, IPCOBJTYPE_CODE, IPCOBJECT_NAME, PARAM_NAME, 
LOADINGMODE_CODE, REGLAMENTTYPE_CODE)
TABLESPACE EDSC_META
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          80K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );