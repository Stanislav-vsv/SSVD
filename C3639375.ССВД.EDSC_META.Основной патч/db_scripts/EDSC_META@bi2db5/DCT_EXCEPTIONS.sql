begin
execute immediate 'drop table DCT_EXCEPTIONS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE DCT_EXCEPTIONS
(
  EXCEPTION_CODE          NUMBER(38)            NOT NULL,
  EXCEPTION_NAME          VARCHAR2(255 BYTE)    NOT NULL,
  EXCEPTION_DESC          VARCHAR2(512 BYTE),
  EXCEPTION_MSG_TEMPLATE  VARCHAR2(512 BYTE)    NOT NULL,
  CHANGE_DATE             DATE                  DEFAULT SYSDATE               NOT NULL,
  PATCH_CODE       VARCHAR2(128 BYTE)           NOT NULL
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

COMMENT ON TABLE DCT_EXCEPTIONS IS '������� ����������';

COMMENT ON COLUMN DCT_EXCEPTIONS.EXCEPTION_CODE IS '��� ����������';

COMMENT ON COLUMN DCT_EXCEPTIONS.EXCEPTION_NAME IS 'SQL- ��� ����������';

COMMENT ON COLUMN DCT_EXCEPTIONS.EXCEPTION_DESC IS '����������� ����������';

COMMENT ON COLUMN DCT_EXCEPTIONS.EXCEPTION_MSG_TEMPLATE IS '������ ��������� ����������';

COMMENT ON COLUMN DCT_EXCEPTIONS.CHANGE_DATE IS '���� ���������� ��������� ���������� � �������.';

COMMENT ON COLUMN DCT_EXCEPTIONS.PATCH_CODE IS '����� ���������� �����, � ������� ������� ���������.';
