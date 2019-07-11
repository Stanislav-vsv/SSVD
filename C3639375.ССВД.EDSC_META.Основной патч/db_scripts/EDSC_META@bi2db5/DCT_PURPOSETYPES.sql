begin
execute immediate 'drop table DCT_PURPOSETYPES CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE DCT_PURPOSETYPES
(
  PURPOSETYPE_CODE  VARCHAR2(25 BYTE)           NOT NULL,
  PURPOSETYPE_NAME  VARCHAR2(255 BYTE)          NOT NULL,
  PURPOSETYPE_DESC  VARCHAR2(512 BYTE),
  CHANGE_DATE       DATE                        DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE        VARCHAR2(128 BYTE)          NOT NULL
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

CREATE UNIQUE INDEX DCT_PURPOSETYPES_PK ON DCT_PURPOSETYPES
(PURPOSETYPE_CODE)
TABLESPACE EDSC_META;

ALTER TABLE DCT_PURPOSETYPES ADD (
  CONSTRAINT DCT_PURPOSETYPES_PK
  PRIMARY KEY
  (PURPOSETYPE_CODE)
  USING INDEX DCT_PURPOSETYPES_PK
  ENABLE VALIDATE);

COMMENT ON TABLE DCT_PURPOSETYPES IS '���� ��������������� ���������� �������� IPC';

COMMENT ON COLUMN DCT_PURPOSETYPES.PURPOSETYPE_CODE IS '��� ���� ��������������� ����������';

COMMENT ON COLUMN DCT_PURPOSETYPES.PURPOSETYPE_NAME IS '������������ ���� ��������������� ����������';

COMMENT ON COLUMN DCT_PURPOSETYPES.PURPOSETYPE_DESC IS '�������� ���� ��������������� ����������';

COMMENT ON COLUMN DCT_PURPOSETYPES.CHANGE_DATE IS '���� ���������� ��������� ���������� � �������.';

COMMENT ON COLUMN DCT_PURPOSETYPES.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';