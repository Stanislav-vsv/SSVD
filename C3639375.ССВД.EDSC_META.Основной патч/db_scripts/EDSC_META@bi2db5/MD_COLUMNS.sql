begin
execute immediate 'drop table MD_COLUMNS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_COLUMNS
(
  SCHEMA_NAME         VARCHAR2(30 BYTE)         NOT NULL,
  TABLE_NAME          VARCHAR2(30 BYTE)         NOT NULL,
  COLUMN_NAME         VARCHAR2(30 BYTE)         NOT NULL,
  COLUMNTYPE_CODE     VARCHAR2(1 BYTE)          NOT NULL,
  DELETEDKEY_FLAG     VARCHAR2(1 BYTE)          NOT NULL,
  NVL_FLAG            VARCHAR2(1 BYTE)          NOT NULL,
  DEFAULT_VALUE       VARCHAR2(4000 BYTE),
  REF_SCHEME_NAME     VARCHAR2(30 BYTE),
  REF_TABLE_NAME      VARCHAR2(30 BYTE),
  REF_EXPRESSION_SQL  VARCHAR2(512 BYTE),
  INSNEWKEY_FLAG      VARCHAR2(1 BYTE),
  CHANGE_DATE         DATE                      NOT NULL,
  PATCH_CODE          VARCHAR2(128 BYTE)
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

COMMENT ON TABLE MD_COLUMNS IS '�������� ������ �������';

COMMENT ON COLUMN MD_COLUMNS.SCHEMA_NAME IS 'SQL-��� �����, � ������� ��������� ������� �������';

COMMENT ON COLUMN MD_COLUMNS.TABLE_NAME IS 'SQL-��� ������� �������, ��� ������� ������������ �������';

COMMENT ON COLUMN MD_COLUMNS.COLUMN_NAME IS 'SQL-��� �������� �������, ��� �������� ���������� ��������.';

COMMENT ON COLUMN MD_COLUMNS.COLUMNTYPE_CODE IS '��� ��������� ����';

COMMENT ON COLUMN MD_COLUMNS.DELETEDKEY_FLAG IS '���� ���� ��� ����������� ����� ��� ��������.';

COMMENT ON COLUMN MD_COLUMNS.NVL_FLAG IS '���� ���� ��� ����������� ��������� �������������� ����� �������� NVL.';

COMMENT ON COLUMN MD_COLUMNS.DEFAULT_VALUE IS '�������� �� ���������';

COMMENT ON COLUMN MD_COLUMNS.REF_SCHEME_NAME IS 'SQL-��� �����, � ������� ��������� �������, �� ������� ��������� �������.';

COMMENT ON COLUMN MD_COLUMNS.REF_TABLE_NAME IS 'SQL-��� �������, �� ������� ��������� �������.';

COMMENT ON COLUMN MD_COLUMNS.REF_EXPRESSION_SQL IS 'SQL-��� �����, � ������� ��������� �������, �� ������� ��������� �������.';

COMMENT ON COLUMN MD_COLUMNS.INSNEWKEY_FLAG IS 'SQL-��� �����, � ������� ��������� �������, �� ������� ��������� �������.';

COMMENT ON COLUMN MD_COLUMNS.CHANGE_DATE IS '���� ���������� ��������� ���������� � ���������';

COMMENT ON COLUMN MD_COLUMNS.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX MD_COLUMNS_PK ON MD_COLUMNS
(SCHEMA_NAME, TABLE_NAME, COLUMN_NAME)
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