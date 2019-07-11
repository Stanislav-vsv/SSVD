begin
execute immediate 'drop table DCT_STATUSES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE DCT_STATUSES
(
  STATUS_CODE  VARCHAR2(25 BYTE)                NOT NULL,
  STATUS_NAME  VARCHAR2(255 BYTE)               NOT NULL,
  STATUS_DESC  VARCHAR2(512 BYTE),
  CHANGE_DATE  DATE                             DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE   VARCHAR2(128 BYTE)               NOT NULL
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

COMMENT ON TABLE DCT_STATUSES IS '������� �������� ������';

COMMENT ON COLUMN DCT_STATUSES.STATUS_CODE IS '��� �������';

COMMENT ON COLUMN DCT_STATUSES.STATUS_NAME IS '����������� �������';

COMMENT ON COLUMN DCT_STATUSES.STATUS_DESC IS '�������� ���� ��������������� ����������';

COMMENT ON COLUMN DCT_STATUSES.CHANGE_DATE IS '���� ���������� ��������� ���������� � �������.';

COMMENT ON COLUMN DCT_STATUSES.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';

CREATE UNIQUE INDEX EDSC_META.DCT_STATUSES_PK ON EDSC_META.DCT_STATUSES
(STATUS_CODE)
LOGGING
TABLESPACE EDSC_META;

ALTER TABLE EDSC_META.DCT_STATUSES ADD (
  CONSTRAINT DCT_STATUSES_PK
  PRIMARY KEY
  (STATUS_CODE)
  USING INDEX EDSC_META.DCT_STATUSES_PK
  ENABLE VALIDATE);
