begin
execute immediate 'drop table LOG_ERRORS CASCADE CONSTRAINTS ';
exception when others
  then null;
end;
/

CREATE TABLE LOG_ERRORS
(
  EXCEPTION_CODE  NUMBER(38)                    NOT NULL,
  EXCEPTION_NAME  VARCHAR2(255 BYTE)            DEFAULT 'e_system_error'      NOT NULL,
  ERRMSG_TEXT     VARCHAR2(4000 BYTE)           NOT NULL,
  PLSQLUNIT_NAME  VARCHAR2(256 BYTE)            NOT NULL,
  SEVERITY_CODE   VARCHAR2(1 BYTE)              NOT NULL,
  SQLERRM_TEXT    VARCHAR2(4000 BYTE),
  ERROR_TMST      TIMESTAMP(6)                  DEFAULT SYSTIMESTAMP          NOT NULL
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

COMMENT ON TABLE LOG_ERRORS IS '������ ����������� ������ ���������� ';

COMMENT ON COLUMN LOG_ERRORS.EXCEPTION_CODE IS '��� ������/��������������. ������������� ���� ����������.';

COMMENT ON COLUMN LOG_ERRORS.EXCEPTION_NAME IS '�������� ������/��������������.';

COMMENT ON COLUMN LOG_ERRORS.ERRMSG_TEXT IS '��������� �� ������/��������������';

COMMENT ON COLUMN LOG_ERRORS.PLSQLUNIT_NAME IS '��� PL/SQL ���������/������� � ������� ��������� ������.';

COMMENT ON COLUMN LOG_ERRORS.SEVERITY_CODE IS '������� �����������. ��������� ��������:�E� � ������,�W� � ��������������';

COMMENT ON COLUMN LOG_ERRORS.SQLERRM_TEXT IS '���������, ������������ �������� SQLERRM.';

COMMENT ON COLUMN LOG_ERRORS.ERROR_TMST IS '���� ����������� ������';