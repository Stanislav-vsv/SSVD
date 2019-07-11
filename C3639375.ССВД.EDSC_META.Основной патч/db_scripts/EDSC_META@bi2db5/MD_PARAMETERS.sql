begin
execute immediate 'drop table MD_PARAMETERS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_PARAMETERS
(
  PARAM_NAME     VARCHAR2(128 BYTE)             NOT NULL,
  PARAM_DESC     VARCHAR2(4000 BYTE)            NOT NULL,
  DATATYPE_CODE  VARCHAR2(128 BYTE)             NOT NULL,
  ACTIVE_FLAG    VARCHAR2(1 BYTE)               NOT NULL,
  CHANGE_DATE    DATE                           NOT NULL,
  PATCH_CODE     VARCHAR2(128 BYTE)
)
TABLESPACE EDSC_META;

COMMENT ON TABLE MD_PARAMETERS IS '������ ����������';

COMMENT ON COLUMN MD_PARAMETERS.PARAM_NAME IS '���������� ��� ��������� � ������� IPC ';

COMMENT ON COLUMN MD_PARAMETERS.PARAM_DESC IS '�������� ���������� ���������.';

COMMENT ON COLUMN MD_PARAMETERS.DATATYPE_CODE IS '��� ������� IPC, ��� �������� ������������ ��������� ETL. ������ �� ������� DCT_IPCOBJTYPES';

COMMENT ON COLUMN MD_PARAMETERS.ACTIVE_FLAG IS '���������� �������, ������������ �������� �������� ����������� ��� ���. ';

COMMENT ON COLUMN MD_PARAMETERS.CHANGE_DATE IS '���� ���������� ��������� ���������� � ���������';

COMMENT ON COLUMN MD_PARAMETERS.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX MD_PARAMETERS_PK ON MD_PARAMETERS
(PARAM_NAME)
TABLESPACE EDSC_META;

ALTER TABLE MD_PARAMETERS ADD (
  CONSTRAINT MD_PARAMETERS_PK
  PRIMARY KEY
  (PARAM_NAME)
  USING INDEX MD_PARAMETERS_PK
  ENABLE VALIDATE);