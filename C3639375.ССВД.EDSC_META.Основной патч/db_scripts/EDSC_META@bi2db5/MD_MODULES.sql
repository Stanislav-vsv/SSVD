begin
execute immediate 'drop table MD_MODULES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE MD_MODULES
(
  MODULE_CODE   VARCHAR2(128 BYTE)              NOT NULL,
  MODULE_NAME   VARCHAR2(128 BYTE)              NOT NULL,
  VERSION_CODE  VARCHAR2(25 BYTE)               NOT NULL,
  VENDOR_CODE   VARCHAR2(128 BYTE)              NOT NULL,
  MODULE_DESC   VARCHAR2(4000 BYTE)             NOT NULL,
  CHANGE_DATE   DATE                            NOT NULL,
  PATCH_CODE    VARCHAR2(128 BYTE)
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

COMMENT ON TABLE MD_MODULES IS '������';

COMMENT ON COLUMN MD_MODULES.MODULE_CODE IS '���������� ��� ������.';

COMMENT ON COLUMN MD_MODULES.MODULE_NAME IS '������������ ������.';

COMMENT ON COLUMN MD_MODULES.VERSION_CODE IS '����� ������ ������.';

COMMENT ON COLUMN MD_MODULES.VENDOR_CODE IS '��� �������, ������� �������� ����������� ������.';

COMMENT ON COLUMN MD_MODULES.MODULE_DESC IS '�������� ������';

COMMENT ON COLUMN MD_MODULES.CHANGE_DATE IS '���� ���������� ��������� ���������� � ���������';

COMMENT ON COLUMN MD_MODULES.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX MD_MODULES_PK ON MD_MODULES
(MODULE_CODE)
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